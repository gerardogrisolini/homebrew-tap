class MlxServer < Formula
  desc "Local LLM server and coding agent powered by MLX on Apple Silicon"
  homepage "https://github.com/gerardogrisolini/mlx-server"
  url "https://github.com/gerardogrisolini/mlx-server/releases/download/v0.3.0/mlx-server-v0.3.0-macos-arm64.tar.gz"
  version "0.3.0"
  version_scheme 1
  sha256 "6ca210ad7de9821d0def784c8192781137731a1595be614356262b12af8af5b8"
  license "MIT"

  depends_on macos: :tahoe

  def install
    bin.install "mlx-server"
    bin.install "mlx-coder"
    bin.install "mlx-voice-transcriber"
    bin.install "mlx.metallib" if File.exist?("mlx.metallib")
    bin.install "mlx.metallib.manifest.json" if File.exist?("mlx.metallib.manifest.json")

    # Install feature executables
    features_dir = libexec/"features"
    features_dir.install Dir["features/*"]

    # Create wrapper scripts for features so they're on PATH
    Dir["features/*"].each do |feature|
      feature_name = File.basename(feature)
      (bin/feature_name).write_env_script(features_dir/feature_name, {})
    end
  end

  def caveats
    <<~EOS
      mlx-server requires macOS 26 (Tahoe) on Apple Silicon.

      After installing, run:
        mlx-server --setup
        mlx-server --setup-models

      For the coding agent:
        mlx-server --coder --cwd /path/to/project

      Or standalone:
        mlx-coder --setup
        mlx-coder --cwd /path/to/project
    EOS
  end

  test do
    assert_match "mlx-server", shell_output("#{bin}/mlx-server --version")
    assert_match "mlx-voice-transcriber", shell_output("#{bin}/mlx-voice-transcriber --help")
  end
end
