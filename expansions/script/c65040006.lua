--黯食偶像 雷士米西斯
function c65040006.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65040006)
	e1:SetCost(c65040006.spcost)
	e1:SetTarget(c65040006.sptg)
	e1:SetOperation(c65040006.spop)
	c:RegisterEffect(e1)
	 --remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c65040006.recost)
	e2:SetTarget(c65040006.retg)
	e2:SetOperation(c65040006.reop)
	c:RegisterEffect(e2)
	--back
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetCondition(c65040006.bccon)
	e3:SetTarget(c65040006.bctg)
	e3:SetOperation(c65040006.bcop)
	c:RegisterEffect(e3)
	--reg
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetOperation(c65040006.regop)
	c:RegisterEffect(e4)
end
function c65040006.cfilter(c,ft)
	return c:IsSetCard(0x3da3) and c:IsReleasable() 
end
function c65040006.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.IsExistingMatchingCard(c65040006.cfilter,tp,LOCATION_MZONE,0,2,e:GetHandler(),ft) end
	local sg=Duel.SelectMatchingCard(tp,c65040006.cfilter,tp,LOCATION_MZONE,0,2,2,e:GetHandler(),ft)
	Duel.Release(sg,REASON_COST)
end
function c65040006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c65040006.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c65040006.cfilter2(c,ft)
	return c:IsSetCard(0x3da3) and c:IsReleasable() and (ft>0 or (ft<=0 and c:IsLocation(LOCATION_MZONE)))
end
function c65040006.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.IsExistingMatchingCard(c65040006.cfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler(),ft) end
	local sg=Duel.SelectMatchingCard(tp,c65040006.cfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,e:GetHandler(),ft)
	Duel.Release(sg,REASON_COST)
end

function c65040006.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c65040006.reop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end

function c65040006.bccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(65040006)==0
end

function c65040006.bctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_GRAVE)
end
function c65040006.bcop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		if Duel.SendtoHand(e:GetHandler(),tp,REASON_EFFECT)~=0 then
			local life=Duel.GetLP(tp)
			Duel.SetLP(tp,life-1200)
		end
	end
end

function c65040006.regop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()==PHASE_END then
	e:GetHandler():RegisterFlagEffect(65040006,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
	end
end
