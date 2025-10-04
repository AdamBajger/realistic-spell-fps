/// Engine crate unit tests

#[cfg(test)]
mod tests {
    use engine::physics_core::PhysicsWorld;

    #[test]
    fn test_physics_world_creation() {
        let _world = PhysicsWorld::new();
        assert!(true);
    }
}
