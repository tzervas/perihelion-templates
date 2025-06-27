package io.perihelion.library.util;

import com.google.common.base.Preconditions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Utility class for string operations.
 */
public final class StringUtils {
    private static final Logger logger = LoggerFactory.getLogger(StringUtils.class);

    private StringUtils() {
        throw new AssertionError("Utility class should not be instantiated");
    }

    /**
     * Reverses a string while maintaining the case of each character.
     *
     * @param input the string to reverse
     * @return the reversed string with preserved case
     * @throws IllegalArgumentException if input is null
     */
    public static String reversePreservingCase(String input) {
        Preconditions.checkArgument(input != null, "Input string cannot be null");
        
        logger.debug("Reversing string: {}", input);
        
        char[] chars = input.toCharArray();
        int left = 0;
        int right = chars.length - 1;
        
        while (left < right) {
            // Swap characters while preserving case
            char leftChar = chars[left];
            char rightChar = chars[right];
            
            boolean leftUpper = Character.isUpperCase(leftChar);
            boolean rightUpper = Character.isUpperCase(rightChar);
            
            chars[left] = rightUpper ? Character.toUpperCase(rightChar) : Character.toLowerCase(rightChar);
            chars[right] = leftUpper ? Character.toUpperCase(leftChar) : Character.toLowerCase(leftChar);
            
            left++;
            right--;
        }
        
        String result = new String(chars);
        logger.debug("Reversed result: {}", result);
        return result;
    }
}
