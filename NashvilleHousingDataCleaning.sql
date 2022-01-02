/*
cleaning data 
*/
select *
from PortfolioProject1..Nashvillehousingdata

--standardize date format
select saledate
from PortfolioProject1..Nashvillehousingdata 

ALTER Table Nashvillehousingdata
add saledateconverted date;

update Nashvillehousingdata
set saledateconverted = convert(date, saledate)

select saledateconverted
from PortfolioProject1..Nashvillehousingdata 

--Populate Property address
select *
from PortfolioProject1..Nashvillehousingdata
--where PropertyAddress is null
order by ParcelID
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject1..Nashvillehousingdata a
Join PortfolioProject1..Nashvillehousingdata b
	on a.ParcelID=b.ParcelID
	And a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a 
Set PropertyAddress=isnull(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject1..Nashvillehousingdata a
Join PortfolioProject1..Nashvillehousingdata b
	on a.ParcelID=b.ParcelID
	And a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

--Breaking out address into Address, City & State

select PropertyAddress
from PortfolioProject1..Nashvillehousingdata
--where PropertyAddress is null
--order by ParcelID

Select 
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) As Address,
Substring(PropertyAddress,CHARINDEX(',',PropertyAddress) +1, Len(PropertyAddress)) As Address
from PortfolioProject1..Nashvillehousingdata

ALTER TABLE Nashvillehousingdata
add PropertySplit_address Nvarchar(255)

Update Nashvillehousingdata
Set PropertySplit_address= SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE Nashvillehousingdata
add Propertysplit_city Nvarchar(255)

Update Nashvillehousingdata
Set Propertysplit_city= Substring(PropertyAddress,CHARINDEX(',',PropertyAddress) +1, Len(PropertyAddress))

Select *
from PortfolioProject1..Nashvillehousingdata

Select OwnerAddress
From PortfolioProject1..Nashvillehousingdata

Select 
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
From PortfolioProject1..Nashvillehousingdata

ALTER TABLE Nashvillehousingdata
add OwnerSplit_address Nvarchar(255)

Update Nashvillehousingdata
Set OwnerSplit_address= PARSENAME(Replace(OwnerAddress,',','.'),3)

ALTER TABLE Nashvillehousingdata
add Ownersplit_city Nvarchar(255)

Update Nashvillehousingdata
Set Ownersplit_city= PARSENAME(Replace(OwnerAddress,',','.'),2)

ALTER TABLE Nashvillehousingdata
add Ownersplit_State Nvarchar(255)

Update Nashvillehousingdata
Set Ownersplit_State= PARSENAME(Replace(OwnerAddress,',','.'),1)

Select *
From PortfolioProject1..Nashvillehousingdata

--Replace Y & N with Yes & No resp. in "Sold as Vacant" column
Select distinct(SoldasVacant), count(SoldasVacant) as SoldVacant
from PortfolioProject1..Nashvillehousingdata
group by SoldAsVacant

Select SoldasVacant
,Case When SoldasVacant='Y' Then 'Yes'
	When SoldasVacant='N' Then 'No'
	Else SoldasVacant
	End  as Soldvacant
From PortfolioPRoject1..Nashvillehousingdata

Update Nashvillehousingdata
Set SoldAsVacant = Case When SoldasVacant='Y' Then 'Yes'
	When SoldasVacant='N' Then 'No'
	Else SoldasVacant
	End  

--Remove Duplicates
With RowNumCTE AS(
Select *,
Row_Number() Over(
PARTITION BY ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			Order By
				UniqueID
				) row_num
From PortfolioProject1..Nashvillehousingdata
--Order By ParcelID
)
Select *
From RowNumCTE
where row_num>1
Order by PropertyAddress

Select * 
From PortfolioProject1..Nashvillehousingdata

--Delete Unused Columns

Select *
From PortfolioProject1..Nashvillehousingdata

Alter Table PortfolioProject1..Nashvillehousingdata
Drop Column PropertyAddress, SaleDate, OwnerAddress, Taxdistrict

Select *
From PortfolioProject1..Nashvillehousingdata