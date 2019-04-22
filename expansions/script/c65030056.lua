--终景里的抗争者
function c65030056.initial_effect(c)
	 --field!
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c65030056.con)
	e1:SetCost(c65030056.cost)
	e1:SetTarget(c65030056.tg)
	e1:SetOperation(c65030056.op)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,65030056)
	e2:SetOperation(c65030056.regop)
	c:RegisterEffect(e2)
end
function c65030056.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c65030056.thcon)
	e1:SetOperation(c65030056.thop)
	e1:SetReset(RESET_PHASE+PHASE_DRAW)
	Duel.RegisterEffect(e1,tp)
end
function c65030056.refil(c)
	return c:IsSetCard(0x6da2) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c65030056.thcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsExistingMatchingCard(c65030056.refil,tp,LOCATION_DECK,0,1,nil)
end
function c65030056.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,65030056)
	local g=Duel.SelectMatchingCard(tp,c65030056.refil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
		local rg=Duel.GetOperatedGroup()
		rg:KeepAlive()
		local tc,fid=rg:GetFirst(),e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(65030056,RESET_EVENT+RESETS_STANDARD,0,0,fid)
		local m=3
		if Duel.GetTurnPlayer()==tp then
			m=0
		elseif Duel.GetTurnPlayer()~=tp then
			m=1
		end
		if m==0 then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		e2:SetCountLimit(1)
		e2:SetCondition(c65030056.endcon1)
		e2:SetOperation(c65030056.endop)
		e2:SetLabelObject(tc)
		e2:SetLabel(fid)
		Duel.RegisterEffect(e2,tp)
		elseif m==1 then
			local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetReset(RESET_PHASE+PHASE_END,2)
		e3:SetCountLimit(1)
		e3:SetCondition(c65030056.endcon2)
		e3:SetOperation(c65030056.endop)
		e3:SetLabelObject(tc)
		e3:SetLabel(fid)
			Duel.RegisterEffect(e3,tp)
		end
	end
end
function c65030056.endcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c65030056.endcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c65030056.spfilter(c,e,tp)
	return c:GetFlagEffectLabel(65030056)==e:GetLabel() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65030056.endop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,65030056)
	local mc=e:GetLabelObject()
	if c65030056.spfilter(mc,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(mc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c65030056.cfilter(c)
	return c:IsFaceup() and c:IsCode(65030052)
end
function c65030056.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c65030056.cfilter,tp,LOCATION_FZONE,0,1,nil)
end
function c65030056.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler(),REASON_COST) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,e:GetHandler(),REASON_COST)
end
function c65030056.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c65030056.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and e:GetHandler():IsLocation(LOCATION_HAND+LOCATION_GRAVE) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end