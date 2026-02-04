# 🧱 The Wall: Architectural Rules

### EN:
1. **Domain Isolation:** Code from `Domain A` cannot import from `Domain B`.
2. **Shared is UI-only:** No business logic in the `shared/` folder.
3. **Pure Logic:** Domain logic must be separated from UI components.

### PT:
1. **Isolamento de Domínio:** Código do `Domínio A` não pode importar do `Domínio B`.
2. **Shared é apenas UI:** Sem lógica de negócio na pasta `shared/`.
3. **Lógica Pura:** A lógica de domínio deve estar separada dos componentes de UI.
