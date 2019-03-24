--秋夜少女·本田未央
function c81009010.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,81009010)
	e1:SetCost(c81009010.spcost)
	e1:SetTarget(c81009010.sptg)
	e1:SetOperation(c81009010.spop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(c81009010.indcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
	--token
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,81009910)
	e4:SetCost(c81009010.spcost2)
	e4:SetTarget(c81009010.sptg2)
	e4:SetOperation(c81009010.spop2)
	c:RegisterEffect(e4)
end
function c81009010.fselect(c,tp,rg,sg)
	sg:AddCard(c)
	local res=c81009010.fgoal(tp,sg) or rg:IsExists(c81009010.fselect,1,sg,tp,rg,sg)
	sg:RemoveCard(c)
	return res
end
function c81009010.relfilter(c,g)
	return g:IsContains(c)
end
function c81009010.fgoal(tp,sg)
	if sg:GetCount()>0 and Duel.GetMZoneCount(tp,sg)>0 then
		Duel.SetSelectedCard(sg)
		return Duel.CheckReleaseGroup(tp,nil,0,nil)
	else return false end
end
function c81009010.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetReleaseGroup(tp):Filter(Card.IsType,nil,TYPE_TOKEN)
	local g=Group.CreateGroup()
	if chk==0 then return rg:IsExists(c81009010.fselect,1,nil,tp,rg,g) end
	while true do
		local mg=rg:Filter(c81009010.fselect,g,tp,rg,g)
		if mg:GetCount()==0 or (c81009010.fgoal(tp,g) and not Duel.SelectYesNo(tp,210)) then break end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=Duel.SelectReleaseGroup(tp,c81009010.relfilter,1,1,nil,mg)
		g:Merge(sg)
	end
	e:SetLabel(g:GetCount())
	Duel.Release(g,REASON_COST)
end
function c81009010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c81009010.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local ct=e:GetLabel()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*800)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end
function c81009010.indcon(e)
	return Duel.IsExistingMatchingCard(Card.IsType,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,TYPE_TOKEN)
end
function c81009010.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c81009010.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81009010.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c81009010.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c81009010.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,81009002,0,0x4011,1000,1000,4,RACE_FAIRY,ATTRIBUTE_FIRE) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c81009010.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,81009002,0,0x4011,1000,1000,4,RACE_FAIRY,ATTRIBUTE_FIRE) then
		local token=Duel.CreateToken(tp,81009002)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
