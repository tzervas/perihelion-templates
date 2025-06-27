package io.perihelion.library.util;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

class StringUtilsTest {

    @ParameterizedTest
    @CsvSource({
        "Hello,olleH",
        "Java,avaJ",
        "OpenSource,ecruoSnepO",
        "camelCase,esaClemaC"
    })
    void reversePreservingCase_ShouldReverseStringAndMaintainCase(String input, String expected) {
        assertThat(StringUtils.reversePreservingCase(input))
            .isEqualTo(expected);
    }

    @Test
    void reversePreservingCase_ShouldHandleEmptyString() {
        assertThat(StringUtils.reversePreservingCase(""))
            .isEmpty();
    }

    @Test
    void reversePreservingCase_ShouldHandleSingleCharacter() {
        assertThat(StringUtils.reversePreservingCase("A"))
            .isEqualTo("A");
    }

    @Test
    void reversePreservingCase_ShouldThrowExceptionForNullInput() {
        assertThatThrownBy(() -> StringUtils.reversePreservingCase(null))
            .isInstanceOf(IllegalArgumentException.class)
            .hasMessage("Input string cannot be null");
    }

    @Test
    void constructor_ShouldThrowException() {
        assertThatThrownBy(() -> {
            var constructor = StringUtils.class.getDeclaredConstructor();
            constructor.setAccessible(true);
            constructor.newInstance();
        })
            .hasCauseInstanceOf(AssertionError.class)
            .cause()
            .hasMessage("Utility class should not be instantiated");
    }
}
