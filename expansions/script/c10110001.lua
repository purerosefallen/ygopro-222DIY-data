--元素火花 阿纳希塔
function c10110001.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10110001,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c10110001.spcon)
	e1:SetOperation(c10110001.spop)
	c:RegisterEffect(e1)
	--send to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10110002,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,10110001)
	e2:SetTarget(c10110001.tgtg)
	e2:SetOperation(c10110001.tgop)
	e2:SetLabel(TYPE_TRAP+TYPE_SPELL)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10110001,1))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCountLimit(1,10110101)
	e4:SetTarget(c10110001.tgtg)
	e4:SetLabel(TYPE_MONSTER)
	e4:SetOperation(c10110001.tgop)
	c:RegisterEffect(e4)	
end
function c10110001.tgfilter(c,cardtype)
	return c:IsSetCard(0x9332) and c:IsAbleToGrave() and c:IsType(cardtype)
end
function c10110001.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10110001.tgfilter,tp,LOCATION_DECK,0,1,nil,e:GetLabel()) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c10110001.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10110001.tgfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
	   Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c10110001.spfilter(c,ft)
	return (c:IsSetCard(0x9332) or c:IsAttribute(ATTRIBUTE_WATER)) and c:IsAbleToRemoveAsCost() and (ft>0 or (c:GetSequence()<5 and c:IsOnField())) and c:IsType(TYPE_MONSTER)
end
function c10110001.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c10110001.spfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,c,ft)
end
function c10110001.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,c10110001.spfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,c,ft):GetFirst()
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(10110001,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		e1:SetLabel(fid)
		e1:SetCountLimit(1)
		e1:SetCondition(c10110001.retcon)
		e1:SetOperation(c10110001.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c10110001.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc,fid=e:GetLabelObject(),e:GetLabel()
	return tc:GetFlagEffectLabel(10110001)==fid
end
function c10110001.retop(e,tp,eg,ep,ev,re,r,rp)
	if tc:IsPreviousLocation(LOCATION_HAND) then
	   Duel.SendtoHand(tc,tc:GetPreviousControler(),REASON_EFFECT)
	else
	   Duel.ReturnToField(tc)
	end
end