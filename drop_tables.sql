EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL';
EXEC sp_MSforeachtable 'DROP TABLE ?';
