class MlxCoder < Formula
  desc "Local coding agent and LLM server powered by MLX on Apple Silicon"
  homepage "https://github.com/gerardogrisolini/mlx-coder"
  url "https://github.com/gerardogrisolini/mlx-coder/releases/download/v0.3.5/mlx-server-v0.3.5-macos-arm64.tar.gz"
  version "0.3.5"
  version_scheme 1
  sha256 "32b2a07094337e417d04fdda00901fdbbd975c295c5b85b2dbb5dd0813826a94"
  license "MIT"

  depends_on macos: :tahoe

  def install
    bin.install "mlx-coder"
    bin.install "mlx-server"
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
      mlx-coder requires macOS 26 (Tahoe) on Apple Silicon.

      After installing, run:
        mlx-coder --setup
        mlx-coder --cwd /path/to/project

      The local inference server is also included:
        mlx-server --setup
        mlx-server --setup-models
        mlx-server
    EOS
  end

  test do
    assert_match "mlx-coder", shell_output("#{bin}/mlx-coder --version")
    assert_match "mlx-server", shell_output("#{bin}/mlx-server --version")
  end
end
