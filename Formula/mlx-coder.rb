class MlxCoder < Formula
  desc "Local coding agent powered by MLX on Apple Silicon"
  homepage "https://github.com/gerardogrisolini/mlx-coder"
  url "https://github.com/gerardogrisolini/mlx-coder/releases/download/v0.3.8/mlx-coder-v0.3.8-macos-arm64.tar.gz"
  version "0.3.8"
  version_scheme 1
  sha256 "e1bc9c888523d3f1646083af7236426839b9c73c72c689b0909f5ec6a560eced"
  license "MIT"

  depends_on macos: :tahoe

  def install
    bin.install "mlx-coder"
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

      To use the local MLX runtime directly:
        mlx-coder --mlx
    EOS
  end

  test do
    assert_match "mlx-coder", shell_output("#{bin}/mlx-coder --version")
  end
end
