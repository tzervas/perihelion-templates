package validator

import (
	"errors"
	"fmt"
	"unicode/utf8"

	"go.uber.org/zap"
)

// Common validation errors
var (
	ErrEmptyString    = errors.New("string is empty")
	ErrExceedsLength  = errors.New("string exceeds maximum length")
	ErrInvalidEncoding = errors.New("string contains invalid UTF-8 characters")
)

// StringValidationOptions defines the configuration for string validation.
type StringValidationOptions struct {
	// AllowEmpty determines if empty strings are considered valid
	AllowEmpty bool
	// MaxLength specifies the maximum allowed string length in runes (Unicode characters)
	// If set to 0, no maximum length is enforced
	MaxLength int
	// RequireUTF8 specifies whether the string must be valid UTF-8
	RequireUTF8 bool
}

// StringValidator provides string validation functionality.
type StringValidator struct {
	opts   StringValidationOptions
	logger *zap.Logger
}

// NewStringValidator creates a new StringValidator with the given options.
func NewStringValidator(opts StringValidationOptions) *StringValidator {
	logger, _ := zap.NewProduction()
	return &StringValidator{
		opts:   opts,
		logger: logger,
	}
}

// WithLogger sets a custom logger for the validator.
func (v *StringValidator) WithLogger(logger *zap.Logger) *StringValidator {
	v.logger = logger
	return v
}

// Validate checks if a string meets the validation criteria.
func (v *StringValidator) Validate(s string) error {
	// Check for empty string if not allowed
	if !v.opts.AllowEmpty && s == "" {
		v.logger.Debug("empty string validation failed")
		return ErrEmptyString
	}

	// Check UTF-8 encoding if required
	if v.opts.RequireUTF8 && !utf8.ValidString(s) {
		v.logger.Debug("UTF-8 validation failed")
		return ErrInvalidEncoding
	}

	// Check maximum length if specified
	if v.opts.MaxLength > 0 {
		runeCount := utf8.RuneCountInString(s)
		if runeCount > v.opts.MaxLength {
			v.logger.Debug("maximum length validation failed",
				zap.Int("maxLength", v.opts.MaxLength),
				zap.Int("actualLength", runeCount),
			)
			return fmt.Errorf("%w: max %d, got %d", ErrExceedsLength, v.opts.MaxLength, runeCount)
		}
	}

	return nil
}

// ValidateAll validates multiple strings and returns all validation errors.
func (v *StringValidator) ValidateAll(strings ...string) []error {
	var errors []error
	for i, s := range strings {
		if err := v.Validate(s); err != nil {
			v.logger.Debug("validation failed for string",
				zap.Int("index", i),
				zap.Error(err),
			)
			errors = append(errors, fmt.Errorf("string at index %d: %w", i, err))
		}
	}
	return errors
}
