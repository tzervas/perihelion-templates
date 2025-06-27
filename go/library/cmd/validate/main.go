package main

import (
	"flag"
	"fmt"
	"os"

	"github.com/tzervas/perihelion-templates/go/library/pkg/validator"
	"go.uber.org/zap"
)

func main() {
	// Parse command line flags
	maxLength := flag.Int("max-length", 0, "maximum string length (0 for unlimited)")
	allowEmpty := flag.Bool("allow-empty", false, "allow empty strings")
	requireUTF8 := flag.Bool("require-utf8", true, "require valid UTF-8 encoding")
	flag.Parse()

	// Get strings to validate from command line arguments
	strings := flag.Args()
	if len(strings) == 0 {
		fmt.Println("Usage: validate [flags] string1 [string2 ...]")
		flag.PrintDefaults()
		os.Exit(1)
	}

	// Setup logger
	logger, _ := zap.NewDevelopment()
	defer logger.Sync()

	// Create validator with options from flags
	v := validator.NewStringValidator(validator.StringValidationOptions{
		MaxLength:  *maxLength,
		AllowEmpty: *allowEmpty,
		RequireUTF8: *requireUTF8,
	}).WithLogger(logger)

	// Validate all strings
	errors := v.ValidateAll(strings...)

	// Print results
	if len(errors) == 0 {
		fmt.Println("All strings are valid!")
		os.Exit(0)
	}

	fmt.Printf("Found %d validation errors:\n", len(errors))
	for _, err := range errors {
		fmt.Printf("- %v\n", err)
	}
	os.Exit(1)
}
