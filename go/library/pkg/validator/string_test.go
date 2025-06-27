package validator

import (
	"errors"
	"testing"

	"github.com/stretchr/testify/assert"
	"go.uber.org/zap"
)

func TestStringValidator_Validate(t *testing.T) {
	tests := []struct {
		name    string
		opts    StringValidationOptions
		input   string
		wantErr error
	}{
		{
			name:    "empty string not allowed",
			opts:    StringValidationOptions{AllowEmpty: false},
			input:   "",
			wantErr: ErrEmptyString,
		},
		{
			name:    "empty string allowed",
			opts:    StringValidationOptions{AllowEmpty: true},
			input:   "",
			wantErr: nil,
		},
		{
			name: "exceeds max length",
			opts: StringValidationOptions{
				MaxLength: 5,
			},
			input:   "123456",
			wantErr: ErrExceedsLength,
		},
		{
			name: "within max length",
			opts: StringValidationOptions{
				MaxLength: 5,
			},
			input:   "12345",
			wantErr: nil,
		},
		{
			name: "invalid UTF-8 when required",
			opts: StringValidationOptions{
				RequireUTF8: true,
			},
			input:   string([]byte{0xff, 0xfe, 0xfd}),
			wantErr: ErrInvalidEncoding,
		},
		{
			name: "valid UTF-8",
			opts: StringValidationOptions{
				RequireUTF8: true,
			},
			input:   "Hello, 世界",
			wantErr: nil,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			logger := zap.NewNop()
			v := NewStringValidator(tt.opts).WithLogger(logger)
			err := v.Validate(tt.input)

			if tt.wantErr != nil {
				assert.True(t, errors.Is(err, tt.wantErr))
			} else {
				assert.NoError(t, err)
			}
		})
	}
}

func TestStringValidator_ValidateAll(t *testing.T) {
	v := NewStringValidator(StringValidationOptions{
		AllowEmpty: false,
		MaxLength:  5,
	})

	errors := v.ValidateAll(
		"",           // should fail: empty
		"123456",     // should fail: too long
		"valid",      // should pass
		"also valid", // should fail: too long
	)

	assert.Len(t, errors, 3)
	assert.True(t, errors[0] != nil && errors[1] != nil && errors[2] != nil)
}

func TestStringValidator_WithLogger(t *testing.T) {
	logger := zap.NewNop()
	v := NewStringValidator(StringValidationOptions{})
	v = v.WithLogger(logger)

	assert.Same(t, logger, v.logger)
}
