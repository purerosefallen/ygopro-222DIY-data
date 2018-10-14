--元素火花 伊玛
function c10110003.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10110003,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c10110003.spcon)
	e1:SetOperation(c10110003.spop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10110003,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,10110003)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c10110003.sptg2)
	e2:SetOperation(c10110003.spop2)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10110003,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCountLimit(1,10110103)
	e3:SetCode(EVENT_REMOVE)
	e3:SetTarget(c10110003.sptg3)
	e3:SetOperation(c10110003.spop3)
	c:RegisterEffect(e3)  
end
function c10110003.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c10110003.dfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c10110003.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tc=Duel.SelectMatchingCard(tp,c10110003.dfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT+REASON_DISCARD)~=0 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	   local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10110003.spfilter2),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,tc:GetAttribute(),e,tp)
	   if sg:GetCount()>0 then
		  Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	   end
	end
end
function c10110003.dfilter(c,e,tp)
	return c:IsSetCard(0x9332) and c:IsType(TYPE_MONSTER) and c:IsDiscardable() and Duel.IsExistingMatchingCard(c10110003.spfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c:GetAttribute(),e,tp)
end
function c10110003.spfilter2(c,att,e,tp)
	return c:IsSetCard(0x9332) and not c:IsAttribute(att) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetLevel()==3
end
function c10110003.spfilter(c,ft)
	return (c:IsSetCard(0x9332) or c:IsAttribute(ATTRIBUTE_EARTH)) and c:IsAbleToRemoveAsCost() and (ft>0 or (c:GetSequence()<5 and c:IsOnField())) and c:IsType(TYPE_MONSTER)
end
function c10110003.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c10110003.spfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,c,ft)
end
function c10110003.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,c10110003.spfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,c,ft):GetFirst()
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(10110003,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		e1:SetLabel(fid)
		e1:SetCountLimit(1)
		e1:SetCondition(c10110003.retcon)
		e1:SetOperation(c10110003.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c10110003.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc,fid=e:GetLabelObject(),e:GetLabel()
	return tc:GetFlagEffectLabel(10110003)==fid
end
function c10110003.retop(e,tp,eg,ep,ev,re,r,rp)
	if tc:IsPreviousLocation(LOCATION_HAND) then
	   Duel.SendtoHand(tc,tc:GetPreviousControler(),REASON_EFFECT)
	else
	   Duel.ReturnToField(tc)
	end
end
function c10110003.sptg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) or c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_REMOVED)
end
function c10110003.spop3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local sp=(Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
	local th=c:IsAbleToHand()
	if not sp and not th then return end
	if th and (not sp or not Duel.SelectYesNo(tp,aux.Stringid(10110003,3))) then
	   Duel.SendtoHand(c,nil,REASON_EFFECT)
	else
	   Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
