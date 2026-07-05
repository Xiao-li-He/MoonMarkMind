///|
async fn main {
  run() catch {
    e => {
      println("Failed to export mind map: \{e}")
      @sys.exit(1)
    }
  }
}
