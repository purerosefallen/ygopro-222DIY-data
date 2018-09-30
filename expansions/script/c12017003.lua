--忍妖 百变
function c12017003.initial_effect(c)
	--fusion substitute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_FUSION_SUBSTITUTE)
	e2:SetCondition(c12017003.subcon)
	c:RegisterEffect(e2)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12017003,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c12017003.sctg)
	e2:SetOperation(c12017003.scop)
	c:RegisterEffect(e2)  
end
function c12017003.subcon(e)
	return e:GetHandler():IsLocation(0x1e)
end
function c12017003.tgfilter(c,rc)
	if not c:IsType(TYPE_MONSTER) or not c:IsAbleToGrave() then return false end
	local code=c:GetCode()
	local e1=Effect.CreateEffect(rc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetValue(code)
	rc:RegisterEffect(e1)
	local bool=Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,rc)
	e1:Reset()
	return bool
end
function c12017003.mfilter(c)
	return c:IsSetCard(0xfb4) 
end
function c12017003.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12017003.tgfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c12017003.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(c12017003.mfilter,tp,LOCATION_MZONE,0,nil)
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c12017003.tgfilter,tp,LOCATION_DECK,0,1,1,nil,c):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
	   local e1=Effect.CreateEffect(c)
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_CHANGE_CODE)
	   e1:SetValue(tc:GetCode())
	   e1:SetReset(RESET_EVENT+0x1ff0000)
	   c:RegisterEffect(e1)
	   if c:GetControler()==tp then 
		  local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c)
		  if g:GetCount()>0 then
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			 local sg=g:Select(tp,1,1,nil)
			 Duel.SynchroSummon(tp,sg:GetFirst(),c,mg)
		  end
	   end
	   local e2=Effect.CreateEffect(c)
	   e2:SetType(EFFECT_TYPE_FIELD)
	   e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	   e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	   e2:SetTargetRange(1,0)
	   e2:SetValue(c12017003.aclimit)
	   e2:SetLabelObject(tc)
	   e2:SetReset(RESET_PHASE+PHASE_END)
	   Duel.RegisterEffect(e2,tp)
	   local e3=Effect.CreateEffect(c)
	   e3:SetType(EFFECT_TYPE_FIELD)
	   e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	   e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	   e3:SetReset(RESET_PHASE+PHASE_END)
	   e3:SetTargetRange(1,0)
	   e3:SetTarget(c12017003.sumlimit)
	   e3:SetLabelObject(tc)
	   Duel.RegisterEffect(e3,tp)
	   local e4=e3:Clone()
	   e4:SetCode(EFFECT_CANNOT_SUMMON)
	   Duel.RegisterEffect(e4,tp)
	end
end
function c12017003.sumlimit(e,c)
	return c:IsCode(e:GetLabelObject():GetCode())
end
function c12017003.aclimit(e,re,tp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsCode(tc:GetCode()) and not re:GetHandler():IsImmuneToEffect(e)
end
function c12017003.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tct=Duel.GetTurnCount()
	Duel.RegisterFlagEffect(rp,12017003+tct,RESET_PHASE+PHASE_END,0,2)
end