import unittest
import os
import json
import tempfile
from datetime import datetime, timedelta


class ConfigManager:
    """Configuration manager for the application."""

    def __init__(self, config_path):
        self.config_path = config_path
        self.config = self._load_config()

    def _load_config(self):
        """Load configuration from file."""
        if not os.path.exists(self.config_path):
            return {}

        try:
            with open(self.config_path, 'r') as f:
                return json.load(f)
        except json.JSONDecodeError:
            print(f"Error: Config file {self.config_path} is not valid JSON")
            return {}

    def save_config(self):
        """Save configuration to file."""
        with open(self.config_path, 'w') as f:
            json.dump(self.config, f, indent=2)

    def get(self, key, default=None):
        """Get a configuration value."""
        return self.config.get(key, default)

    def set(self, key, value):
        """Set a configuration value."""
        self.config[key] = value
        self.save_config()


class FileCache:
    """Simple file-based cache implementation."""

    def __init__(self, cache_dir, default_ttl=3600):
        self.cache_dir = cache_dir
        self.default_ttl = default_ttl

        if not os.path.exists(cache_dir):
            os.makedirs(cache_dir)

    def _get_cache_path(self, key):
        """Generate the file path for a cache key."""
        return os.path.join(self.cache_dir, f"{key}.cache")

    def set(self, key, value, ttl=None):
        """Set a value in the cache."""
        if ttl is None:
            ttl = self.default_ttl

        expiry = datetime.now() + timedelta(seconds=ttl)

        cache_data = {
            'value': value,
            'expiry': expiry.timestamp()
        }

        with open(self._get_cache_path(key), 'w') as f:
            json.dump(cache_data, f)

    def get(self, key, default=None):
        """Get a value from the cache."""
        cache_path = self._get_cache_path(key)

        if not os.path.exists(cache_path):
            return default

        try:
            with open(cache_path, 'r') as f:
                cache_data = json.load(f)

            expiry = cache_data.get('expiry')
            if expiry and datetime.now().timestamp() > expiry:
                os.remove(cache_path)
                return default

            return cache_data.get('value')
        except:
            return default

    def delete(self, key):
        """Delete a value from the cache."""
        cache_path = self._get_cache_path(key)

        if os.path.exists(cache_path):
            os.remove(cache_path)


class TestConfigManager(unittest.TestCase):
    """Test case for ConfigManager class."""

    def setUp(self):
        # Create a temporary file for testing
        self.temp_file = tempfile.NamedTemporaryFile(delete=False)
        self.config_path = self.temp_file.name
        self.temp_file.close()

        # Initialize with empty config
        with open(self.config_path, 'w') as f:
            json.dump({}, f)

        self.config_manager = ConfigManager(self.config_path)

    def tearDown(self):
        os.unlink(self.config_path)

    def test_get_default(self):
        """Test getting a non-existent value returns the default."""
        self.assertEqual(self.config_manager.get('non_existent', 'default'), 'default')

    def test_set_and_get(self):
        """Test setting and then getting a value."""
        self.config_manager.set('test_key', 'test_value')
        self.assertEqual(self.config_manager.get('test_key'), 'test_value')

    def test_save_and_load(self):
        """Test saving and then loading configuration."""
        self.config_manager.set('test_key', 'test_value')

        # Create a new instance to load from the same file
        new_config_manager = ConfigManager(self.config_path)
        self.assertEqual(new_config_manager.get('test_key'), 'test_value')


if __name__ == '__main__':
    unittest.main()
