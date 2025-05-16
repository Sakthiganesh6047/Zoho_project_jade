package util;

import java.time.Instant;
import java.time.ZoneId;
import java.time.ZonedDateTime;

public class TimeConversion {

    /**
     * Converts a Unix timestamp in milliseconds to a ZonedDateTime in the specified time zone.
     *
     * @param unixMillis the Unix timestamp in milliseconds
     * @param zoneId     the desired time zone (e.g., ZoneId.of("Asia/Kolkata"))
     * @return           a ZonedDateTime representing the local time
     */
    public static ZonedDateTime toZonedDateTime(long unixMillis, ZoneId zoneId) {
        return Instant.ofEpochMilli(unixMillis).atZone(zoneId);
    }
}

