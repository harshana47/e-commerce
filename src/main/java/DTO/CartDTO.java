package DTO;

import java.math.BigDecimal;

public class CartDTO {
    private int id;
    private int userId;
    private ProductDTO product;
    private int quantity;
    private BigDecimal totalPrice;

    public CartDTO(int id, int userId, ProductDTO product, int quantity, BigDecimal totalPrice) {
        this.id = id;
        this.userId = userId;
        this.product = product;
        this.quantity = quantity;
        this.totalPrice = totalPrice;
    }

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

    public ProductDTO getProduct() {
        return product;
    }

    public void setProduct(ProductDTO product) {
        this.product = product;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }
}
