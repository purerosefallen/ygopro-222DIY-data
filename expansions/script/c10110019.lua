--暗镒素 瓦由
function c10110019.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10110019,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCost(c10110019.spcost)
	e1:SetTarget(c10110019.sptg)
	e1:SetOperation(c10110019.spop)
	c:RegisterEffect(e1)
	--fusion
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_FUSION_ATTRIBUTE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(0x1f)
	e2:SetValue(ATTRIBUTE_EARTH+ATTRIBUTE_FIRE+ATTRIBUTE_WATER+ATTRIBUTE_WIND)
	c:RegisterEffect(e2)
	--Remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10110019,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCountLimit(1,10110019)
	e3:SetCode(EVENT_REMOVE)
	e3:SetTarget(c10110019.rmtg)
	e3:SetOperation(c10110019.rmop)
	c:RegisterEffect(e3)  
end
function c10110019.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10110019.rfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c10110019.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10110019.rfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
	   Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c10110019.rfilter(c)
	return c:IsSetCard(0x9332) and c:IsAbleToRemove()
end
function c10110019.spfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c:IsSetCard(0x9332) and c:IsFaceup()
end
function c10110019.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c10110019.spfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10110019.spfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,2,2,nil)
	if Duel.Remove(g,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
	   local rg,fid=Duel.GetOperatedGroup(),c:GetFieldID()
	   for tc in aux.Next(rg) do
		   tc:RegisterFlagEffect(10110019,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
	   end
	   rg:KeepAlive()
	   local e1=Effect.CreateEffect(c)
	   e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	   e1:SetCode(EVENT_PHASE+PHASE_END)
	   e1:SetReset(RESET_PHASE+PHASE_END)
	   e1:SetLabelObject(rg)
	   e1:SetLabel(fid)
	   e1:SetCountLimit(1)
	   e1:SetCondition(c10110019.retcon)
	   e1:SetOperation(c10110019.retop)
	   Duel.RegisterEffect(e1,tp)
	end
end
function c10110019.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10110019.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10110019.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	return g:IsExists(c10110019.retfilter,1,nil,e:GetLabel())
end
function c10110019.retfilter(c,fid)
	return c:GetFlagEffectLabel(10110019)==fid
end
function c10110019.retop(e,tp,eg,ep,ev,re,r,rp)
	local g,ft=e:GetLabelObject(),Duel.GetLocationCount(tp,LOCATION_MZONE)
	local sg=g:Filter(c10110019.retfilter,nil,e:GetLabel())
	g:DeleteGroup()
	if sg:GetCount()>0 then
	   local sg1=sg:Filter(Card.IsPreviousLocation,nil,LOCATION_GRAVE)
	   local sg2=sg:Filter(Card.IsPreviousLocation,nil,LOCATION_MZONE)
	   if sg1:GetCount()>0 then
		  Duel.SendtoGrave(sg1,REASON_EFFECT+REASON_RETURN)
	   end
	   if sg2:GetCount()>0 then
		  if sg2:GetCount()==2 and ft<2 and ft>0 then
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			 local rc=sg2:Select(tp,1,1,nil):GetFirst()
			 Duel.ReturnToField(rc)
			 sg2:RemoveCard(rc)
		  end
		  for tc in aux.Next(sg2) do
			  Duel.ReturnToField(tc)
		  end
	   end
	end
end