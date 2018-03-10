--神匠器 吹雪
function c10126011.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10126011,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetTarget(c10126011.eqtg)
	e1:SetOperation(c10126011.eqop)
	c:RegisterEffect(e1) 
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10126011,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c10126011.spcon)
	e2:SetTarget(c10126011.sptg)
	e2:SetOperation(c10126011.spop)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(300)
	c:RegisterEffect(e3) 
	local e4=e3:Clone() 
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4) 
end
function c10126011.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_RELEASE)
end
function c10126011.spfilter(c,e,tp)
	return c:IsSetCard(0x1335) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10126011.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10126011.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c10126011.spop(e,tp,eg,ep,ev,re,r,rp)
	local c,op=e:GetHandler(),0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10126011.spfilter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) and c:IsLocation(LOCATION_GRAVE) then
	   local sp=(c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
	   local eq=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	   if not sp and not eq then return end
	   if sp and eq then
		  op=Duel.SelectOption(tp,aux.Stringid(10126011,2),aux.Stringid(10126011,3),aux.Stringid(10126011,4))
	   elseif sp then
		  op=Duel.SelectOption(tp,aux.Stringid(10126011,2),aux.Stringid(10126011,3))
	   else
		  op=Duel.SelectOption(tp,aux.Stringid(10126011,2),aux.Stringid(10126011,4))
		  if op==1 then op=2 end
	   end
	   if op==1 then
		  Duel.BreakEffect()
		  Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	   elseif op==2 then
		  Duel.BreakEffect()
		  if not Duel.Equip(tp,c,tc,true) then return end
		  local e1=Effect.CreateEffect(c)
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetCode(EFFECT_EQUIP_LIMIT)
		  e1:SetReset(RESET_EVENT+0x1fe0000)
		  e1:SetLabelObject(tc)
		  e1:SetValue(c10126011.eqlimit)
		  c:RegisterEffect(e1)
	   else
	   end
	end
end
function c10126011.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x1335)
end
function c10126011.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c10126011.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c10126011.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c10126011.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c10126011.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc,true) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetLabelObject(tc)
	e1:SetValue(c10126011.eqlimit)
	c:RegisterEffect(e1)
end
function c10126011.eqlimit(e,c)
	return c==e:GetLabelObject()
end