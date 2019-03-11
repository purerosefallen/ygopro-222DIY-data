--Trancer Doll's
function c81010006.initial_effect(c)
	c:SetUniqueOnField(1,0,81010006)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetRange(LOCATION_SZONE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_LINK_SPELL_KOISHI)
	e0:SetValue(LINK_MARKER_TOP_RIGHT+LINK_MARKER_TOP_LEFT)
	c:RegisterEffect(e0)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81010006+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c81010006.con)
	e1:SetTarget(c81010006.tg)
	e1:SetOperation(c81010006.op)
	c:RegisterEffect(e1)
	--ritual summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetCountLimit(1,81010096)
	e2:SetCondition(c81010006.spcon)
	e2:SetCost(c81010006.spcost)
	e2:SetTarget(c81010006.sptg)
	e2:SetOperation(c81010006.spop)
	c:RegisterEffect(e2)
end
function c81010006.nfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM)
end
function c81010006.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81010006.nfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c81010006.filter(c)
	return c:IsCode(81010000) and c:IsAbleToHand()
end
function c81010006.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81010006.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c81010006.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c81010006.filter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c81010006.dfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM) and c:IsLevelAbove(7)
end
function c81010006.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.IsExistingMatchingCard(c81010006.dfilter,tp,LOCATION_MZONE,0,1,nil) and (bit.band(r,REASON_BATTLE)~=0 or (bit.band(r,REASON_EFFECT)~=0 and rp==1-tp))
end
function c81010006.cfilter(c,e,tp)
	return c:GetType()&0x81==0x81 and c:IsType(TYPE_PENDULUM) and Duel.IsExistingMatchingCard(c81010006.spfilter,tp,LOCATION_HAND,0,1,c,e,tp)
		and Duel.GetMZoneCount(tp,c)>0
end
function c81010006.spfilter(c,e,tp)
	return c:GetType()&0x81==0x81 and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false)
end
function c81010006.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c81010006.cfilter,1,nil,e,tp) end
	local g=Duel.SelectReleaseGroupEx(tp,c81010006.cfilter,1,1,nil,e,tp)
	Duel.Release(g,REASON_COST)
end
function c81010006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81010006.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c81010006.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81010006.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP) then
		tc:CompleteProcedure()
	end
end
