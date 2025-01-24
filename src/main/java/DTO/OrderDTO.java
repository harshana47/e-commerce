package DTO;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class OrderDTO {
    private int id;
    private int userId;
    private Timestamp orderDate;
    private BigDecimal total;
    private String status;

    public OrderDTO() {
    }

    public OrderDTO(int id, int userId, Timestamp orderDate, BigDecimal total, String status) {
        this.id = id;
        this.userId = userId;
        this.orderDate = orderDate;
        this.total = total;
        this.status = status;
    }

    public OrderDTO(int id, String orderDate, double total) {
        this.id = id;
        this.orderDate = Timestamp.valueOf(orderDate);
        this.total = new BigDecimal(total);
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Timestamp getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Timestamp orderDate) {
        this.orderDate = orderDate;
    }

    public BigDecimal getTotal() {
        return total;
    }

    public void setTotal(BigDecimal total) {
        this.total = total;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
