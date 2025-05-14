import unittest
from src.main import hello_world

class TestMain(unittest.TestCase):
    def test_hello_world(self):
        self.assertEqual(hello_world(), "Hello, Boot.dev!")

if __name__ == "__main__":
    unittest.main()
