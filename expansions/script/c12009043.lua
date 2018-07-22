--歌姬的祝祭 蕾恩缇娅
function c12009043.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12009043,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,12009043)
	e1:SetCondition(c12009043.hspcon)
	e1:SetTarget(c12009043.hsptg)
	e1:SetOperation(c12009043.hspop)
	c:RegisterEffect(e1) 
	--synchro effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12009043,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,12009143)
	e2:SetTarget(c12009043.sctg)
	e2:SetOperation(c12009043.scop)
	c:RegisterEffect(e2)  
	if not c12009043.global_check then
		c12009043.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c12009043.checkop)
		Duel.RegisterEffect(ge1,0)
	end 
end
function c12009043.tgfilter(c,rc)
	if not c:IsType(TYPE_MONSTER) or not c:IsAbleToGrave() then return false end
	local code=c:GetCode()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetValue(code)
	c:RegisterEffect(e1)
	local bool=Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,rc)
	e1:Reset()
	return bool
end
function c12009043.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12009043.tgfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c12009043.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c12009043.tgfilter,tp,LOCATION_DECK,0,1,1,nil,c):GetFirst()
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
			 Duel.SynchroSummon(tp,sg:GetFirst(),c)
		  end
	   end
	   local e2=Effect.CreateEffect(c)
	   e2:SetType(EFFECT_TYPE_FIELD)
	   e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	   e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	   e2:SetTargetRange(1,0)
	   e2:SetValue(c12009043.aclimit)
	   e2:SetLabelObject(tc)
	   e2:SetReset(RESET_PHASE+PHASE_END)
	   Duel.RegisterEffect(e2,tp)
	   local e3=Effect.CreateEffect(c)
	   e3:SetType(EFFECT_TYPE_FIELD)
	   e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	   e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	   e3:SetReset(RESET_PHASE+PHASE_END)
	   e3:SetTargetRange(1,0)
	   e3:SetTarget(c12009043.sumlimit)
	   e3:SetLabelObject(tc)
	   Duel.RegisterEffect(e3,tp)
	   local e4=e3:Clone()
	   e4:SetCode(EFFECT_CANNOT_SUMMON)
	   Duel.RegisterEffect(e4,tp)
	end
end
function c12009043.sumlimit(e,c)
	return c:IsCode(e:GetLabelObject():GetCode())
end
function c12009043.aclimit(e,re,tp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsCode(tc:GetCode()) and not re:GetHandler():IsImmuneToEffect(e)
end
function c12009043.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tct=Duel.GetTurnCount()
	Duel.RegisterFlagEffect(rp,12009043+tct,RESET_PHASE+PHASE_END,0,2)
end
function c12009043.hspcon(e,tp,eg,ep,ev,re,r,rp)
	local tct=Duel.GetTurnCount()-1
	return Duel.GetFlagEffect(1-tp,12009043+tct)>0 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c12009043.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c12009043.hspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
	   Duel.Draw(tp,1,REASON_EFFECT)
	end
end
