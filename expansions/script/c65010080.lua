--终末旅者装备 连发霰弹枪
function c65010080.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65010080+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c65010080.cost)
	e1:SetTarget(c65010080.target)
	e1:SetOperation(c65010080.activate)
	c:RegisterEffect(e1)
end
c65010080.setname="RagnaTravellers"
function c65010080.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c65010080.desfilter(c,tc,ec)
	return c:GetEquipTarget()~=tc and c~=ec
end
function c65010080.costfilter(c,ec)
	if not c:IsRace(RACE_WARRIOR) then return false end
	return Duel.IsExistingTarget(c65010080.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,c,ec)
end
function c65010080.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc~=c end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.CheckReleaseGroup(tp,c65010080.costfilter,1,c,c)
		else
			return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
		end
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local sg=Duel.SelectReleaseGroup(tp,c65010080.costfilter,1,1,c,c)
		Duel.Release(sg,REASON_COST)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c65010080.tgfil(c)
	return (c.setname=="RagnaTravellers" or c:IsCode(65010082)) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c65010080.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.Destroy(sg,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c65010080.tgfil,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(65010080,0)) then
		local gg=Duel.SelectMatchingCard(tp,c65010080.tgfil,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(gg,REASON_EFFECT)
	end
end