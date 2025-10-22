/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.proyectopedidoenvio;
import java.sql.*;
/**
 *
 * @author solyo
 */
public class PedidoSeguridad {
    private static final String URL = "jdbc:mysql://127.0.0.1:3306/Pedido_Envio?serverTimezone=UTC";
    private static final String USER = "usuario_prueba";
    private static final String PASS = "ClaveSegura123";

    public static void main(String[] args) {
        try {
            // 1) PreparedStatement: consulta segura por numero
            buscarPedidoSeguro("PED-TEST-001");                 // búsqueda válida
            buscarPedidoSeguro("' OR '1'='1");                  // intento clásico de inyección
            buscarPedidoSeguro("PED-TEST-001'; DROP TABLE Pedido; --"); // intento malicioso

            // 2) INSERT seguro con PreparedStatement (prueba de parametrización en escritura)
            insertarPedidoSeguro(2001, "PED-JAVA-001", "Cliente Java", 500.00, "NUEVO");

            // 3) Llamada a procedimiento almacenado (sin SQL dinámico)
            llamarSP("PED-TEST-001");
            llamarSP("' OR '1'='1"); // intento de inyección contra el SP (debe fallar como búsqueda literal)

        } catch (SQLException e) {
            System.err.println("SQLException: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Consulta SELECT segura (PreparedStatement)
    public static void buscarPedidoSeguro(String numeroPedido) throws SQLException {
        String sql = "SELECT id, numero, fecha, clienteNombre, total, estado FROM Pedido WHERE numero = ? AND eliminado = FALSE";
        try (Connection conn = DriverManager.getConnection(URL, USER, PASS);
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, numeroPedido);
            try (ResultSet rs = ps.executeQuery()) {
                System.out.println("=== Búsqueda segura para: " + numeroPedido + " ===");
                boolean found = false;
                while (rs.next()) {
                    found = true;
                    System.out.printf("id=%d, numero=%s, fecha=%s, cliente=%s, total=%.2f, estado=%s%n",
                        rs.getLong("id"),
                        rs.getString("numero"),
                        rs.getDate("fecha"),
                        rs.getString("clienteNombre"),
                        rs.getBigDecimal("total"),
                        rs.getString("estado"));
                }
                if (!found) {
                    System.out.println("No se encontraron registros.");
                }
                System.out.println();
            }
        }
    }

    // INSERT seguro con PreparedStatement
    public static void insertarPedidoSeguro(long id, String numero, String clienteNombre, double total, String estado) throws SQLException {
        String sql = "INSERT INTO Pedido (id, numero, fecha, clienteNombre, total, estado) VALUES (?, ?, CURDATE(), ?, ?, ?)";
        try (Connection conn = DriverManager.getConnection(URL, USER, PASS);
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, id);
            ps.setString(2, numero);
            ps.setString(3, clienteNombre);
            ps.setDouble(4, total);
            ps.setString(5, estado);

            int filas = ps.executeUpdate();
            System.out.println("INSERT seguro: filas afectadas = " + filas);
        } catch (SQLException e) {
            System.out.println("Error en INSERT seguro: " + e.getMessage());
        }
    }

    // Llamada segura a procedimiento almacenado (CallableStatement)
    public static void llamarSP(String numeroPedido) throws SQLException {
        String sql = "{ CALL sp_get_pedido_por_numero(?) }";
        try (Connection conn = DriverManager.getConnection(URL, USER, PASS);
             CallableStatement cs = conn.prepareCall(sql)) {

            cs.setString(1, numeroPedido);
            try (ResultSet rs = cs.executeQuery()) {
                System.out.println("=== Llamada SP segura para: " + numeroPedido + " ===");
                boolean any = false;
                while (rs.next()) {
                    any = true;
                    System.out.printf("id=%d, numero=%s, total=%.2f%n",
                        rs.getLong("id"),
                        rs.getString("numero"),
                        rs.getBigDecimal("total"));
                }
                if (!any) System.out.println("No se encontraron registros.");
                System.out.println();
            }
        }
    }
}

