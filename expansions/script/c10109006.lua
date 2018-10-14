--促动剂6
function c10109006.initial_effect(c)
	--specialsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(10109006,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_CUSTOM+10109001)
	e1:SetCountLimit(1,10109006)
	e1:SetCondition(c10109006.spcon)
	e1:SetTarget(c10109006.sptg)
	e1:SetOperation(c10109006.spop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_EQUIP)
	c:RegisterEffect(e3)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10109006,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,10109106)
	e2:SetTarget(c10109006.settg)
	e2:SetOperation(c10109006.setop)
	c:RegisterEffect(e2)
end
function c10109006.cfilter(c)
	return not c:IsForbidden() and c:IsSetCard(0x5332) and c:IsType(TYPE_MONSTER)
end
function c10109006.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10109006.cfilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c10109006.cfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>1 end
end
function c10109006.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(c10109006.cfilter,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(c10109006.cfilter,tp,LOCATION_DECK,0,nil)
	if g1:GetCount()<=0 or g2:GetCount()<=0 or Duel.GetLocationCount(tp,LOCATION_SZONE)<=1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tg1=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tg2=g2:Select(tp,1,1,nil)
	tg1:Merge(tg2)
	local tc=tg1:GetFirst()
	while tc do
	   if Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		  local e1=Effect.CreateEffect(c)
		  e1:SetCode(EFFECT_CHANGE_TYPE)
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		  e1:SetReset(RESET_EVENT+0x1fc0000)
		  e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		  tc:RegisterEffect(e1)
	   end
	tc=tg1:GetNext()
	end
	Duel.RaiseEvent(tg1,EVENT_CUSTOM+10109001,e,0,tp,0,0)
end
function c10109006.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c10109006.cfilter2,1,nil,tp) and bit.band(e:GetHandler():GetType(),0x20002)==0x20002
end
function c10109006.cfilter2(c,tp)
	return c:IsSetCard(0x5332) and bit.band(c:GetOriginalType(),TYPE_MONSTER)==TYPE_MONSTER and c:IsControler(tp) and c:IsFaceup()
end
function c10109006.spfilter(c,e,tp)
	return c10109006.cfilter2(c,tp) and  c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCanBeEffectTarget(e)
end
function c10109006.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c10109006.spfilter(chkc,e,tp) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=eg:Filter(c10109006.spfilter,nil,e,tp)
	if chk==0 then return g:GetCount()>0 and ft>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,math.min(2,ft),nil)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,sg:GetCount(),tp,LOCATION_SZONE)
end
function c10109006.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local sg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 and sg:GetCount()<=Duel.GetLocationCount(tp,LOCATION_MZONE) then
	   Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
