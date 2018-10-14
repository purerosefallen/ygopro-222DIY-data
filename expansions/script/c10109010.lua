--咒缚灵 铁骑
function c10109010.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10109010,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,10109010)
	e1:SetCondition(c10109010.spcon)
	e1:SetTarget(c10109010.sptg)
	e1:SetOperation(c10109010.spop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10109010,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,10109110)
	e2:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e2:SetCost(c10109010.setcost)
	e2:SetTarget(c10109010.settg)
	e2:SetOperation(c10109010.setop)
	c:RegisterEffect(e2)
end
function c10109010.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c10109010.tfilter(c,tp)
	return c:IsSetCard(0x5332) and c:IsReleasable() and bit.band(c:GetOriginalType(),TYPE_MONSTER)==TYPE_MONSTER and Duel.IsExistingMatchingCard(c10109010.setfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c10109010.setfilter(c,code)
	return c:IsCode(code) and not c:IsForbidden()
end
function c10109010.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
	   if e:GetLabel()~=1 then return false end
	   e:SetLabel(0)
	   return Duel.IsExistingMatchingCard(c10109010.tfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler(),tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>1 and not e:GetHandler():IsForbidden()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c10109010.tfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,e:GetHandler(),tp)
	Duel.Release(g,REASON_COST)
	e:SetLabel(g:GetFirst():GetCode())
end
function c10109010.setop(e,tp,eg,ep,ev,re,r,rp)
	local c,code=e:GetHandler(),e:GetLabel()
	local g=Duel.GetMatchingGroup(c10109010.setfilter,tp,LOCATION_DECK,0,c,code)
	if not c:IsRelateToEffect(e) or c:IsForbidden() or g:GetCount()<=0 or Duel.GetLocationCount(tp,LOCATION_SZONE)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c10109010.setfilter,tp,LOCATION_DECK,0,1,1,c,code)
	g:AddCard(c)
	local tc=g:GetFirst()
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
	tc=g:GetNext()
	end
	Duel.RaiseEvent(g,EVENT_CUSTOM+10109001,e,0,tp,0,0)
end
function c10109010.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c10109010.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c10109010.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c10109010.spfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_SZONE)
end
function c10109010.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft,tc=Duel.GetLocationCount(tp,LOCATION_MZONE),Duel.GetFirstTarget()
	if ft<=0 or not e:GetHandler():IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end
function c10109010.spfilter(c,e,tp)
	return c:GetSequence()<5 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10109010.cfilter(c)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c10109010.spcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c10109010.cfilter,1,nil) and bit.band(e:GetHandler():GetType(),0x20002)==0x20002
end
