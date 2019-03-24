--吸血姬-赤夜萌香
function c9980004.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980004,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,9980004)
	e1:SetCondition(c9980004.condtion)
	e1:SetTarget(c9980004.target)
	e1:SetOperation(c9980004.operation)
	c:RegisterEffect(e1)
	--reduce atk and draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980004,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetCountLimit(1,99800040)
	e1:SetCondition(c9980004.drcon)
	e1:SetTarget(c9980004.drtg)
	e1:SetOperation(c9980004.drop)
	c:RegisterEffect(e1)
	--reg
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c9980004.drcon)
	e2:SetOperation(c9980004.regop)
	c:RegisterEffect(e2)
end
function c9980004.condtion(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c9980004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local opt=0
	local c=e:GetHandler()
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b2=c:IsAbleToHand()
	if b1 and b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(9980004,1),aux.Stringid(9980004,2))+1
	elseif b1 then
		opt=Duel.SelectOption(tp,aux.Stringid(9980004,1))+1
	elseif b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(9980004,2))+2
	end
	e:SetLabel(opt)
	if opt==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	elseif opt==2 then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	else
		e:SetCategory(0)
	end
end
function c9980004.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 then
		if c:IsRelateToEffect(e) then
			Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
		end
	elseif e:GetLabel()==2 then
		if c:IsRelateToEffect(e) then
			Duel.SendtoHand(c,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,c)
		end
	end
end
function c9980004.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_LINK and c:GetReasonCard():IsSetCard(0xbc2)
end
function c9980004.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=e:GetHandler():GetReasonCard()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and rc:IsAttackAbove(500) and rc:GetFlagEffect(9980004)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9980004.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	if not rc:IsAttackAbove(500) or rc:IsImmuneToEffect(e) or rc:GetFlagEffect(9980004)==0 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1)
	if not rc:IsHasEffect(EFFECT_REVERSE_UPDATE) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c9980004.regop(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	rc:RegisterFlagEffect(9980004,RESET_EVENT+RESETS_STANDARD,0,1)
end

