--心里掌握(<ゝω·)☆ 
function c5012610.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c5012610.mfilter,c5012610.xyzcheck,3,3)
	--draw  
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c5012610.drcon)
	e3:SetOperation(c5012610.drop)
	c:RegisterEffect(e3)
	--control
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_CONTROL)
	e5:SetDescription(aux.Stringid(5012610,0))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c5012610.con)
	e5:SetCost(c5012610.cost)
	e5:SetTarget(c5012610.target)
	e5:SetOperation(c5012610.operation)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetCondition(c5012610.con2)
	e6:SetCost(c5012610.cost2)
	c:RegisterEffect(e6)
end
function c5012610.mfilter(c,xyzc)
	return c:IsFaceup() and (c:IsSetCard(0x250) or c:IsSetCard(0x23c)) and not c:IsType(TYPE_TOKEN) 
end
function c5012610.xyzcheck(g)
	return not g:IsExists(c5012610.xyzfilter,1,nil)
end
function c5012610.xyzfilter(c)
	return not c:IsSetCard(0x250) and not c:IsSetCard(0x23c)
end
function c5012610.over(c,g)
	return c:IsFaceup() and (c:IsSetCard(0x250) or c:IsSetCard(0x23c) ) and c:IsCanBeXyzMaterial(g) and not c:IsType(TYPE_TOKEN) 
end
function c5012610.overcon(e,c)
	if  Duel.IsExistingMatchingCard(c5012610.over,e:GetHandlerPlayer(),LOCATION_MZONE,0,3,nil,e:GetHandler()) then return true
	else return false end
end
function c5012610.overop(e,tp,eg,ep,ev,re,r,rp,c) 
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c5012610.over,e:GetHandlerPlayer(),LOCATION_MZONE,0,3,3,nil,e:GetHandler())
	if g:GetCount()==3  then
	local tg=g:GetFirst()
	while tg do
	local og=tg:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
	tg=g:GetNext()
	end
	Duel.Overlay(c,g)
end
end
function c5012610.filter(c)
	return c:IsCode(5012604)  and  c:IsFaceup()
end
function c5012610.thfilter(c) 
	return c:IsAbleToHand()
end
function c5012610.drcon(e,tp,eg,ep,ev,re,r,rp)
	 return  e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ 
	and Duel.IsExistingMatchingCard(c5012610.filter,tp,LOCATION_ONFIELD,0,1,nil) 
end
function c5012610.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c5012610.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c5012610.con(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,5012604)
end
function c5012610.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c5012610.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()~=tp and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c5012610.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not Duel.GetControl(tc,tp) then
		if not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
function c5012610.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,5012604)
end
function c5012610.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end