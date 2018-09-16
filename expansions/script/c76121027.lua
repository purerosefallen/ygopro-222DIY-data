--神论之决
function c76121027.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,76121027+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c76121027.setcon)
	e1:SetTarget(c76121027.settg)
	e1:SetOperation(c76121027.setop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(76121027,3))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c76121027.ssetcost)
	e2:SetTarget(c76121027.ssettg)
	e2:SetOperation(c76121027.ssetop)
	c:RegisterEffect(e2)
end
function c76121027.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0xea2) and c:IsType(TYPE_MONSTER)
end
function c76121027.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0xea2) and c:IsType(TYPE_LINK)
end
function c76121027.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c76121027.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c76121027.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,1-tp)
end
function c76121027.setfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c76121027.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b1=Duel.IsExistingMatchingCard(c76121027.spfilter,tp,0,LOCATION_GRAVE,1,nil,e,tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
	local b2=Duel.IsExistingMatchingCard(c76121027.setfilter,tp,0,LOCATION_GRAVE,1,nil) and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		if Duel.IsExistingMatchingCard(c76121027.cfilter2,tp,LOCATION_MZONE,0,1,nil) then
			op=Duel.SelectOption(tp,aux.Stringid(76121027,0),aux.Stringid(76121027,1),aux.Stringid(76121027,2))
		else
			op=Duel.SelectOption(tp,aux.Stringid(76121027,0),aux.Stringid(76121027,1))
		end
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(76121027,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(76121027,1))+1
	end
	e:SetLabel(op)
end
function c76121027.setop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op~=1 then
		if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c76121027.spfilter),tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
			if sg:GetCount()>0 then
				local tc1=sg:GetFirst()
				Duel.SpecialSummon(tc1,0,tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
				Duel.ConfirmCards(1-tp,tc1)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				tc1:RegisterEffect(e1,true)
			end
		end
	end
	if op~=0 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c76121027.setfilter),tp,0,LOCATION_GRAVE,1,1,nil)
			if g:GetCount()>0 then
				local tc2=g:GetFirst()
				Duel.SSet(tp,tc2,1-tp)
				Duel.ConfirmCards(1-tp,tc2)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_CANNOT_TRIGGER)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				tc2:RegisterEffect(e2,true)
			end
		end
	end
end
function c76121027.ssetcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c76121027.ssetfilter(c)
	return c:IsSetCard(0xea2) and c:IsType(TYPE_TRAP) and c:IsSSetable() and not c:IsCode(76121027)
end
function c76121027.ssettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c76121027.ssetfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c76121027.ssetop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c76121027.ssetfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end