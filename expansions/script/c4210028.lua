--猫耳天堂-猫耳的仪式
function c4210028.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,4210028)
	e1:SetTarget(c4210028.target)
	e1:SetOperation(c4210028.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c4210028.thcon)
	e2:SetCost(c4210028.thcost)
	e2:SetTarget(c4210028.thtg)
	e2:SetOperation(c4210028.thop)
	c:RegisterEffect(e2)
end
function c4210028.filter(c,e,tp,m1,m2,ft)
	if not(c:IsSetCard(0x2af) and c:IsType(TYPE_MONSTER) and c:GetLevel()==9 and c:IsCanBeSpecialSummoned(e,0,tp,false,true)) then return false end
	local mg=m1:Filter(Card.IsReleasable,c)
	mg:Merge(m2)
	if ft>0 then
		return mg:CheckWithSumEqual(Card.GetLevel,9,1,99,c)
	else
		return ft>-1 and mg:IsExists(c4210028.mfilterf,1,nil,tp,mg,c)
	end
end
function c4210028.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumEqual(Card.GetLevel,9,0,99,rc)
	else return false end
end
function c4210028.repfilter(c)
	return c:GetLevel()>0 and c:IsSetCard(0x2af) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c4210028.relfilter(c)
	return c:GetLevel()>0 and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c4210028.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetMatchingGroup(c4210028.relfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
		local mg2=Duel.GetMatchingGroup(c4210028.repfilter,tp,LOCATION_GRAVE,0,nil)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return Duel.IsExistingMatchingCard(c4210028.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg1,mg2,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c4210028.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetMatchingGroup(c4210028.relfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	local mg2=Duel.GetMatchingGroup(c4210028.repfilter,tp,LOCATION_GRAVE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c4210028.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg1,mg2,ft)
	local tc=tg:GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsReleasable,tc,tc)
		mg:Merge(mg2)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,nil)
		end
		local mat=nil
		if ft>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:SelectWithSumEqual(tp,Card.GetLevel,9,1,99,tc)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:FilterSelect(tp,c4210028.mfilterf,1,1,nil,tp,mg,tc)
			Duel.SetSelectedCard(mat)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat2=mg:SelectWithSumEqual(tp,Card.GetLevel,9,0,99,tc)
			mat:Merge(mat2)
		end				
		local rm= mat:Filter(Card.IsLocation,tp,LOCATION_GRAVE)
		Duel.Remove(rm,POS_FACEUP,REASON_COST)
		Duel.Release(mat,REASON_COST+REASON_RELEASE)
		Duel.SpecialSummon(tc,0,tp,tp,false,true,POS_FACEUP)
		local code = tc:GetCode()
		tc:RegisterFlagEffect(0,RESET_EVENT+0xcff0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(4210010,1))
		tc:RegisterFlagEffect(4210010,RESET_EVENT+0xcff0000,0,0)
		tc:RegisterFlagEffect(0,RESET_EVENT+0xcff0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(code,1))
		tc:RegisterFlagEffect(code,RESET_EVENT+0xcff0000,0,0)
	end
end
function c4210028.cfilter(c)
	return c:IsSetCard(0x2af) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c4210028.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(function(c) return not c:IsSetCard(0x2af) or c:IsFacedown() end,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() end,tp,LOCATION_MZONE,0,1,nil)
end
function c4210028.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c4210028.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c4210028.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c4210028.thfilter(c)
	return c:IsSetCard(0x2af) and c:IsAbleToHand()
end
function c4210028.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4210028.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c4210028.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c4210028.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end