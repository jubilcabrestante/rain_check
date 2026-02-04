import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:rain_check/app/domain/cubit/weather_cubit.dart';
import 'package:rain_check/app/themes/colors.dart';

class WeatherHeader extends StatelessWidget {
  const WeatherHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<WeatherHeaderCubit, WeatherHeaderState>(
      listenWhen: (p, c) => p.errorMessage != c.errorMessage,
      listener: (context, state) {
        final msg = state.errorMessage;
        if (msg == null || msg.isEmpty) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));

        context.read<WeatherHeaderCubit>().clearError();
      },
      builder: (context, state) {
        if (state.loading) {
          return const _LoadingCard(text: 'Loading barangays...');
        }

        return Card(
          elevation: 6,
          clipBehavior: Clip.antiAlias,
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // location + dropdown + refresh
                    Row(
                      children: [
                        const Icon(
                          Icons.pin_drop,
                          size: 28,
                          color: AppColors.textWhite,
                        ),
                        const Gap(8),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            padding: EdgeInsets.only(left: 10),
                            decoration: const InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            iconEnabledColor: AppColors.textGrey,
                            dropdownColor: Colors.white,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: AppColors.textGrey,
                            ),
                            items: state.barangays
                                .map(
                                  (b) => DropdownMenuItem(
                                    value: b.name,
                                    child: Text(
                                      b.name,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: context
                                .read<WeatherHeaderCubit>()
                                .setBarangay,
                          ),
                        ),
                      ],
                    ),
                    const Gap(8),
                    Text(
                      "Today's Forecast",
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppColors.textGrey,
                      ),
                    ),
                    const Gap(16),

                    if (state.loadingWeather)
                      const _InlineLoading(text: 'Fetching weather...')
                    else
                      _WeatherBody(theme: theme),
                    const Gap(24),
                  ],
                ),

                // temp bottom right
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: _TempNow(temp: state.weather?.temperatureC),
                ),

                const Positioned(
                  top: 40,
                  right: 8,
                  child: Icon(
                    Icons.water_drop,
                    size: 70,
                    color: AppColors.textWhite,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _WeatherBody extends StatelessWidget {
  final ThemeData theme;
  const _WeatherBody({required this.theme});

  @override
  Widget build(BuildContext context) {
    final s = context.select<WeatherHeaderCubit, WeatherHeaderState>(
      (c) => c.state,
    );
    final data = s.weather;

    if (data == null) {
      return const Text(
        'No weather data.',
        style: TextStyle(color: AppColors.textWhite),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.cloudy_snowing,
              size: 35,
              color: AppColors.textWhite,
            ),
            const Gap(12),
            Text(
              "${data.chanceOfRainPct}%",
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.textWhite,
              ),
            ),
          ],
        ),
        const Gap(12),
        Text(
          "${data.rainAmountText} showers expected",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textGrey,
          ),
        ),
        Text(
          "Accumulation: ${data.accumulationMm.toStringAsFixed(1)} mm",
          style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textGrey),
        ),
      ],
    );
  }
}

class _TempNow extends StatelessWidget {
  final double? temp;
  const _TempNow({required this.temp});

  @override
  Widget build(BuildContext context) {
    final t = temp;
    return Row(
      children: [
        const Icon(Icons.thermostat, size: 40, color: AppColors.textWhite),
        const Gap(6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Now",
              style: TextStyle(fontSize: 16, color: AppColors.textWhite),
            ),
            Text(
              t == null ? '-- °C' : '${t.toStringAsFixed(0)} °C',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textWhite,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LoadingCard extends StatelessWidget {
  final String text;
  const _LoadingCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _InlineLoading(text: text),
      ),
    );
  }
}

class _InlineLoading extends StatelessWidget {
  final String text;
  const _InlineLoading({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          const CircularProgressIndicator(color: Colors.white),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(color: AppColors.textWhite)),
        ],
      ),
    );
  }
}
