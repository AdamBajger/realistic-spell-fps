use tokio::task;
/// End-to-end test for server-client communication
use tokio::time::{sleep, Duration};

#[tokio::test]
async fn test_server_client_hello_world() {
    // Start server in background task
    let server_task = task::spawn(async {
        let mut server = server::net::NetworkServer::new("127.0.0.1", 7778);
        let _ = server.start().await;
    });

    // Give server time to start
    sleep(Duration::from_millis(100)).await;

    // Create client and connect
    let mut client = client::net::NetworkClient::new();
    let result = client.connect("127.0.0.1", 7778).await;
    assert!(result.is_ok(), "Client should connect to server");

    // Send HELLO message
    let response = client.send_message("HELLO\n").await;
    assert!(response.is_ok(), "Client should send message");
    assert_eq!(
        response.unwrap().trim(),
        "WORLD",
        "Server should respond with WORLD"
    );

    // Send PING message
    let response = client.send_message("PING\n").await;
    assert!(response.is_ok(), "Client should send message");
    assert_eq!(
        response.unwrap().trim(),
        "PONG",
        "Server should respond with PONG"
    );

    // Clean up
    client.disconnect().await.unwrap();
    server_task.abort();
}

#[tokio::test]
async fn test_multiple_clients() {
    // Start server in background task
    let server_task = task::spawn(async {
        let mut server = server::net::NetworkServer::new("127.0.0.1", 7779);
        let _ = server.start().await;
    });

    // Give server time to start
    sleep(Duration::from_millis(100)).await;

    // Create multiple clients
    let mut client1 = client::net::NetworkClient::new();
    let mut client2 = client::net::NetworkClient::new();

    // Both clients connect
    assert!(client1.connect("127.0.0.1", 7779).await.is_ok());
    assert!(client2.connect("127.0.0.1", 7779).await.is_ok());

    // Both clients send messages
    let resp1 = client1.send_message("HELLO\n").await.unwrap();
    let resp2 = client2.send_message("PING\n").await.unwrap();

    assert_eq!(resp1.trim(), "WORLD");
    assert_eq!(resp2.trim(), "PONG");

    // Clean up
    client1.disconnect().await.unwrap();
    client2.disconnect().await.unwrap();
    server_task.abort();
}
