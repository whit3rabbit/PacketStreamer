package config

import (
	"errors"
)

var (
	ErrNoOutputConfigured              = errors.New("no output configured")
	ErrNoPortConfiguredForServerOutput = errors.New("no port configured for server output")
)

func ValidateSensorConfig(config *Config) error {
	if config.Output.File == nil && config.Output.Server == nil {
		return ErrNoOutputConfigured
	}
	if config.Output.Server != nil && config.Output.Server.Port == nil {
		return ErrNoPortConfiguredForServerOutput
	}

	return nil
}
