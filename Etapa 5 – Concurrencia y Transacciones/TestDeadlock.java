/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author facun
 */

import java.sql.*;

public class TestDeadlock {

    // Datos de conexion
    static final String URL = "jdbc:mysql://localhost:3306/tp_pedidoenvio";
    static final String USER = "root"; 
    static final String PASSWORD = "root"; 

    public static void main(String[] args) {

        long idPedido = 1; // Pedido a actualizar
        String estadoPedido = "FACTURADO";
        String estadoEnvio = "EN_TRANSITO";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             CallableStatement stmt = conn.prepareCall("{CALL sp_actualizar_pedido_envio(?, ?, ?)}")) {

            stmt.setLong(1, idPedido);
            stmt.setString(2, estadoPedido);
            stmt.setString(3, estadoEnvio);

            System.out.println("Llamando al procedimiento sp_actualizar_pedido_envio...");
            boolean hasResult = stmt.execute();

            // Leer resultados (mensajes del procedimiento)
            while (hasResult) {
                try (ResultSet rs = stmt.getResultSet()) {
                    while (rs.next()) {
                        System.out.println(rs.getString(1)); // Imprime el mensaje
                    }
                }
                hasResult = stmt.getMoreResults();
            }

            // Verificar estados actuales
            try (Statement st = conn.createStatement()) {
                try (ResultSet rsPedido = st.executeQuery("SELECT id, estado FROM Pedido WHERE id = " + idPedido)) {
                    System.out.println("\nEstado de Pedido:");
                    while (rsPedido.next()) {
                        System.out.println("ID: " + rsPedido.getLong("id") +
                                           ", Estado: " + rsPedido.getString("estado"));
                    }
                }
                try (ResultSet rsEnvio = st.executeQuery(
                        "SELECT e.id, e.estado FROM Envio e JOIN Pedido p ON e.id = p.envio WHERE p.id = " + idPedido)) {
                    System.out.println("\nEstado de Envio:");
                    while (rsEnvio.next()) {
                        System.out.println("ID: " + rsEnvio.getLong("id") +
                                           ", Estado: " + rsEnvio.getString("estado"));
                    }
                }
            }

        } catch (SQLException e) {
            System.err.println("Error de SQL: " + e.getMessage());
        }
    }
}




