const std = @import("std");

// Prints to stdout the current time in UTC in the format YYYY-MM-DD HH:mm:SS.
// TODO: Add support for time zones and local time formatting.
// Library that adds time zones: https://github.com/frmdstryr/zig-datetime
pub fn main() !void {
    const now = std.time.timestamp();

    const epoch_seconds = std.time.epoch.EpochSeconds{ .secs = @intCast(now) };
    const epoch_day = epoch_seconds.getEpochDay();
    const year_day = epoch_day.calculateYearDay();
    const month_day = year_day.calculateMonthDay();
    const day_seconds = epoch_seconds.getDaySeconds();

    const stdout = std.io.getStdOut().writer();
    try stdout.print(
        "{d:0>4}-{d:0>2}-{d:0>2} {d:0>2}:{d:0>2}:{d:0>2}",
        .{
            year_day.year,
            month_day.month.numeric(),
            month_day.day_index + 1,
            day_seconds.getHoursIntoDay(),
            day_seconds.getMinutesIntoHour(),
            day_seconds.getSecondsIntoMinute(),
        },
    );
}
