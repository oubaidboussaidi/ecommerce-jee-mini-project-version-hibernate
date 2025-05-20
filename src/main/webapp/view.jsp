<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.exemple.model.User" %>
<%@ page import="com.exemple.model.Produit" %>
<%@ page import="com.exemple.dao.ProduitDaoImpl" %>

<%
    // Authentication Check
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Load product list
    List<Produit> produits = (List<Produit>) request.getAttribute("produits");
    if (produits == null || produits.isEmpty()) {
        ProduitDaoImpl produitDao = new ProduitDaoImpl();
        produits = produitDao.getAllProduits();
        request.setAttribute("produits", produits);
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>Gestion des Produits</title>
  <style>
    /* ✅ Ton CSS conservé tel quel */
    body {
      font-family: 'Segoe UI', sans-serif;
      background: linear-gradient(to right, #ece9e6, #ffffff);
      margin: 0;
      padding: 40px 20px;
    }
    .container {
      max-width: 900px;
      margin: auto;
      background: #fff;
      padding: 40px;
      border-radius: 16px;
      box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
    }
    h1 {
      text-align: center;
      margin-bottom: 30px;
      color: #00695c;
      font-size: 28px;
      letter-spacing: 1px;
    }
    .tab {
      display: block;
      width: 200px;
      margin: 0 auto 30px auto;
      padding: 12px 24px;
      text-align: center;
      border: 2px solid #00695c;
      border-radius: 50px;
      color: #00695c;
      background-color: #e0f2f1;
      cursor: pointer;
      transition: all 0.3s;
    }
    .tab.active {
      background-color: #00695c;
      color: white;
    }
    .form-section {
      display: block;
      animation: fadeIn 0.4s ease;
    }
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(20px); }
      to { opacity: 1; transform: translateY(0); }
    }
    form {
      text-align: center;
    }
    label {
      display: block;
      margin-bottom: 8px;
      font-weight: 600;
    }
    input[type="text"], input[type="number"] {
      width: 80%;
      max-width: 300px;
      padding: 10px;
      margin-bottom: 20px;
      border-radius: 8px;
      border: 1px solid #ccc;
      font-size: 16px;
    }
    button {
      padding: 12px 24px;
      border: none;
      background-color: #00695c;
      color: white;
      border-radius: 50px;
      font-weight: bold;
      cursor: pointer;
      text-transform: uppercase;
      transition: background-color 0.3s;
    }
    button:hover {
      background-color: #004d40;
    }
    table {
      width: 100%;
      margin-top: 40px;
      border-collapse: collapse;
    }
    th, td {
      border: 1px solid #ccc;
      padding: 14px;
      text-align: center;
    }
    th {
      background-color: #00695c;
      color: white;
      text-transform: uppercase;
    }
    .btn-small {
      padding: 8px 12px;
      font-size: 14px;
      margin: 0 5px;
      border-radius: 6px;
      text-decoration: none;
      color: #00695c;
      border: 1.5px solid #00695c;
      background-color: #e0f2f1;
      cursor: pointer;
      transition: all 0.3s;
      display: inline-block;
    }
    .btn-small:hover {
      background-color: #00695c;
      color: white;
      text-decoration: none;
    }
    .actions {
      display: flex;
      justify-content: center;
      gap: 10px;
    }
    .logout-btn {
      background-color: #c62828;
      margin-bottom: 20px;
    }
    .logout-btn:hover {
      background-color: #8e0000;
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>Bienvenue <%= user.getLogin() %></h1>

    <!-- Logout form -->
    <form action="logout" method="post">
      <button type="submit" class="logout-btn">Déconnexion</button>
    </form>

    <div class="tabs">
      <div id="add-tab" class="tab" onclick="showSection('add')">➕ Ajouter un Produit</div>
      <div id="list-tab" class="tab active" onclick="showSection('list')">📋 Liste des Produits</div>
    </div>

    <div id="add-section" class="form-section" style="display:none;">
      <form action="produits" method="post">
        <input type="hidden" name="action" value="add">

        <label for="nomProduit">Nom du produit</label>
        <input type="text" name="nomProduit" id="nomProduit" required>

        <label for="prix">Prix (€)</label>
        <input type="number" step="0.01" name="prix" id="prix" required>
        <br>
        <button type="submit">Ajouter</button>
      </form>
    </div>

    <div id="list-section" class="form-section" style="display:block;">
      <table>
        <tr>
          <th>ID</th>
          <th>Nom</th>
          <th>Prix</th>
          <th>Actions</th>
        </tr>

        <%
          if (!produits.isEmpty()) {
            for (Produit p : produits) {
        %>
        <tr>
          <td><%= p.getId() %></td>
          <td><%= p.getNomProduit() %></td>
          <td><%= p.getPrix() %></td>
          <td class="actions">
            <!-- Lien de modification avec ID en GET -->
            <a href="editProduit?id=<%= p.getId() %>" class="btn-small" title="Modifier">✏️ Modifier</a>

            <!-- Formulaire suppression POST -->
            <form action="produits" method="post" style="display:inline;" onsubmit="return confirm('Supprimer ce produit ?');">
              <input type="hidden" name="action" value="delete">
              <input type="hidden" name="id" value="<%= p.getId() %>">
              <button class="btn-small" type="submit" title="Supprimer">🗑️ Supprimer</button>
            </form>
          </td>
        </tr>
        <%
            }
          } else {
        %>
        <tr><td colspan="4">Aucun produit trouvé.</td></tr>
        <% } %>
      </table>
    </div>
  </div>

  <script>
    function showSection(section) {
      document.getElementById('add-tab').classList.remove('active');
      document.getElementById('list-tab').classList.remove('active');
      document.getElementById('add-section').style.display = 'none';
      document.getElementById('list-section').style.display = 'none';

      if (section === 'add') {
        document.getElementById('add-tab').classList.add('active');
        document.getElementById('add-section').style.display = 'block';
      } else {
        document.getElementById('list-tab').classList.add('active');
        document.getElementById('list-section').style.display = 'block';
      }
    }
    window.onload = function() {
      showSection('list');
    };
  </script>
</body>
</html>
