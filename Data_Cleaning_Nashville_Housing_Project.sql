CREATE DATABASE HousingData;

USE HousingData;

SELECT *
FROM NashvilleHousing;

-- DATA CLEANING

-- 1. STANDARDIZE DATE FORMAT

SELECT SaleDate, CONVERT(Date, SaleDate)
FROM NashvilleHousing;

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate);

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate);

-- 2. POPULATE PROPERTY ADDRESS DATA

SELECT *
FROM NashvilleHousing;

SELECT *
FROM NashvilleHousing
WHERE PropertyAddress IS NULL;

SELECT *
FROM NashvilleHousing
ORDER BY ParcelID;

SELECT t1.ParcelID, t1.PropertyAddress, t2.ParcelID, t2.PropertyAddress, ISNULL(t1.PropertyAddress,t2.PropertyAddress)
FROM NashvilleHousing AS t1
JOIN NashvilleHousing AS t2
	ON t1.ParcelID = t2.ParcelID
	AND t1.[UniqueID ] <> t2.[UniqueID ]
WHERE t1.PropertyAddress IS NULL;

UPDATE t1
SET PropertyAddress = ISNULL(t1.PropertyAddress,t2.PropertyAddress)
FROM NashvilleHousing AS t1
JOIN NashvilleHousing AS t2
	ON t1.ParcelID = t2.ParcelID
	AND t1.[UniqueID ] <> t2.[UniqueID ]
WHERE t1.PropertyAddress IS NULL;


-- 3. BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (Address, City, State)

SELECT *
FROM NashvilleHousing;

--SELECT PropertyAddress, 
--SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) AS Address,
--SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress)) AS City
--FROM NashvilleHousing;

--ALTER TABLE NashvilleHousing
--ADD Address VARCHAR(50);

--UPDATE NashvilleHousing
--SET Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1);

--ALTER TABLE NashvilleHousing
--ADD City VARCHAR(50);

--UPDATE NashvilleHousing
--SET City = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress));

SELECT PropertyAddress,
PARSENAME(REPLACE(PropertyAddress, ',','.'), 2) AS PropertySplitAddress,
PARSENAME(REPLACE(PropertyAddress, ',','.'), 1) AS PropertySplitCity
FROM NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255)

UPDATE NashvilleHousing
SET PropertySplitAddress = PARSENAME(REPLACE(PropertyAddress, ',','.'), 2);

ALTER TABLE NashvilleHousing
ADD PropertySplitCity VARCHAR(50)

UPDATE NashvilleHousing
SET PropertySplitCity = PARSENAME(REPLACE(PropertyAddress, ',','.'), 1);

SELECT OwnerAddress,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS OwnerSplitAddress,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS OwnerSplitCity,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS OwnerSplitState
FROM NashvilleHousing
ORDER BY OwnerAddress DESC;

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(250);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3);

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity VARCHAR(50);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2);

ALTER TABLE NashvilleHousing
ADD OwnerSplitState VARCHAR(50);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1);


-- 4. CHANGE Y AND N TO Yes AND No IN "SoldAsVacant" field

USE HousingData;

SELECT *
FROM NashvilleHousing;

SELECT DISTINCT SoldAsVacant, COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM NashvilleHousing;

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
						WHEN SoldAsVacant = 'N' THEN 'No'
						ELSE SoldAsVacant
					    END;

-- REMOVE DUPLICATES 

SELECT *
FROM NashvilleHousing;

WITH RowNumCTE as
(
SELECT *, 
ROW_NUMBER() OVER(PARTITION BY ParcelID, 
							   PropertyAddress, 
							   SalePrice, 
							   SaleDate,
							   LegalReference
							   ORDER BY UniqueID) AS Row_Num
FROM NashvilleHousing
)
DELETE
FROM RowNumCTE
WHERE Row_Num > 1;

-- DELETE UNUSED COLUMNS 

SELECT *
FROM NashvilleHousing;

ALTER TABLE NashvilleHousing
DROP COLUMN PropertyAddress, SaleDate, OwnerAddress, TaxDistrict, Address, City, State; 