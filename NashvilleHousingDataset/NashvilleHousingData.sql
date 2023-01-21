

/*Data Cleaning/Scrubbing in SQL */

select *
from NashvilleHousing


--Change Date format 

select saleDate, convert (Date,saledate)
from NashvilleHousing

Update NashvilleHousing
set saleDate = CONVERT(Date, saledate)

alter table nashvillehousing
add saleDateConverted Date;

Update NashvilleHousing
set saleDateConverted = CONVERT(Date, saleDate)

Select saledateconverted, saledate 
from NashvilleHousing


--Clean Property Address 

Select *
from NashvilleHousing
--where propertyAddress is null 
order by ParcelID


Select a.parcelID , a.PropertyAddress, b.parcelID , b.PropertyAddress, ISNULL (a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
Join NashvilleHousing b
on a.parcelID = b.parcelID
and a.uniqueID <> b.uniqueID
where a.propertyaddress is null 


Update a
set propertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
Join NashvilleHousing b
on a.parcelID = b.parcelID
and a.uniqueID <> b.uniqueID


--Breaking out Address into Individual Columns (Address, City, State)

Select propertyaddress
from NashvilleHousing
--where propertyAddress is null 
--order by ParcelID

select 
SUBSTRING (propertyAddress,1, CHARINDEX(',', propertyaddress) -1)as address, 
SUBSTRING (propertyAddress, CHARINDEX(',', propertyaddress)+1 , len(propertyAddress)) as Address 
 from NashvilleHousing

 -- Adding 2 new columns

alter table nashvillehousing
add PropertySplitAddress nvarchar(255);


Update NashvilleHousing
set PropertySplitAddress = SUBSTRING (propertyAddress,1, CHARINDEX(',', propertyaddress) -1)

alter table nashvillehousing
add PropertySplitCity nvarchar(255);

Update NashvilleHousing
set PropertySplitCity = SUBSTRING (propertyAddress, CHARINDEX(',', propertyaddress)+1 , len(propertyAddress))


Select * 
from NashvilleHousing


--- delimiting the Owneraddress column using parsename 

Select Owneraddress 
from NashvilleHousing


Select 
PARSENAME(replace(Owneraddress,',','.'),3),
PARSENAME(replace(Owneraddress,',','.'),2),
PARSENAME(replace(Owneraddress,',','.'),1)
from NashvilleHousing

-- Adding 3 columns after delimiting using parsename

--Adding the 1st table 
alter table nashvillehousing
add OwnerSplitAddress nvarchar(255);

Update NashvilleHousing
set OwnerSplitAddress = PARSENAME(replace(Owneraddress,',','.'),3)

--Adding the 2nd tabke 
alter table nashvillehousing
add OwnerSplitCity nvarchar(255);

Update NashvilleHousing
set OwnerSplitCity = PARSENAME(replace(Owneraddress,',','.'),2)


--Adding the 3rd table 

alter table nashvillehousing
add OwnerSplitState nvarchar(255);

Update NashvilleHousing
set OwnerSplitState = PARSENAME(replace(Owneraddress,',','.'),1)


--Checking the added tables 
Select * 
from NashvilleHousing


-- Change Y and N to yes and no in "Sold as vacant" field

Select distinct(soldasvacant), count(soldasvacant)
from NashvilleHousing
group by soldasvacant
order by 2

--Change Y and N to yes and no using case statement 

select soldasvacant
, case when soldasvacant = 'Y' then 'Yes'
		when soldasvacant = 'N' then 'No'
		else soldasvacant
		end
from NashvilleHousing


Update [NashvilleHousing ]
set soldasvacant = case when soldasvacant = 'Y' then 'Yes'
		when soldasvacant = 'N' then 'No'
		else soldasvacant
		end




---Removing Duplicates 


with rownumCTE as (
Select *, 
	row_number() over (
	partition by parcelID,
				propertyAddress, 
				SalePrice, 
				SaleDate, 
				LegalReference
				Order by 
				uniqueID
				) ROW_NUM 
				
from NashvilleHousing
--order by parcelID 
)
Delete 
from  rownumCTE
Where row_num > 1 
--order by propertyAddress 



--Delete Unused Columns 

Select * 
from NashvilleHousing

Alter table NashvilleHousing 
drop column OwnerAddress, TaxDistrict, PropertyAddress 


--Deleting Sale Date because we have already formated a new column 
Alter table NashvilleHousing 
drop column saleDATE 