class MlxServer < Formula
  desc "Local LLM server and coding agent powered by MLX on Apple Silicon"
  homepage "https://github.com/gerardogrisolini/mlx-server"
  url "https://github.com/gerardogrisolini/mlx-server/releases/download/v0.1.2/mlx-server-v0.1.2-macos-arm64.tar.gz"
  sha256 "02f939bf2bcacdcf0268fff443d319942884181ce6c4c7833abfbda8a1e7b712"
  license "MIT"

  depends_on macos: :tahoe

  def install
    bin.install "mlx-server"
    bin.install "mlx-coder"

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
  end
end
