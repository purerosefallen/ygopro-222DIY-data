--猫耳天堂-
function c4210037.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,
		function(c)return c:IsFusionSetCard(0xa2f) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_LINK) end,
		function(c)return c:IsType(TYPE_MONSTER) and (c:IsType(TYPE_PENDULUM) or c:IsType(TYPE_LINK)) end,false)
	--spsummon
	local ep=Effect.CreateEffect(c)
	ep:SetDescription(aux.Stringid(4210037,0))
	ep:SetCategory(CATEGORY_SPECIAL_SUMMON)
	ep:SetType(EFFECT_TYPE_QUICK_O)
	ep:SetCode(EVENT_FREE_CHAIN)
	ep:SetRange(LOCATION_PZONE)
	ep:SetCondition(c4210037.spcon)
	ep:SetCost(c4210037.spcost)
	ep:SetTarget(c4210037.sptg)
	ep:SetOperation(c4210037.spop)
	c:RegisterEffect(ep)
	--setcard
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c4210037.setcon)
	e1:SetTarget(c4210037.settg)
	e1:SetOperation(c4210037.setop)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4210037,2))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)	
	e2:SetCondition(c4210037.damcon)
	e2:SetOperation(c4210037.damop)
	c:RegisterEffect(e2) 
	--SPSUMMON
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4210037,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_RELEASE)
	e3:SetTarget(c4210037.tgtg)
	e3:SetOperation(c4210037.tgop)
	c:RegisterEffect(e3)
end
function c4210037.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp
end
function c4210037.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,2,nil,0xa2f)
		 and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,4210026) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	Duel.DiscardHand(tp,Card.IsCode,1,1,REASON_COST+REASON_DISCARD,nil,4210026)
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,2,2,nil,0xa2f)	
	Duel.Release(g,REASON_COST)
end
function c4210037.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c4210037.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
end
function c4210037.setfilter(c)
    return c:IsSetCard(0xa2f) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsSSetable()
end
function c4210037.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c4210037.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c4210037.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c4210037.setop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g=Duel.SelectMatchingCard(tp,c4210037.setfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SSet(tp,g:GetFirst())
        Duel.ConfirmCards(1-tp,g)
    end
end
function c4210037.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xa2f) and c:IsType(TYPE_MONSTER)
end
function c4210037.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c4210037.filter,1,nil)
end
function c4210037.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,4210037)
	if Duel.Damage(1-tp,300,REASON_EFFECT) and Duel.IsPlayerCanDraw(1-tp,1) and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)<=7 then
		Duel.Draw(1-tp,1,REASON_EFFECT)
	end
end
function c4210037.tgfilter(c,e,tp)
	return c:IsSetCard(0xa2f) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c4210037.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c4210037.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c4210037.tgfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c4210037.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c4210037.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
			tc:RegisterFlagEffect(0,RESET_EVENT+0xcff0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(4210010,1))
			tc:RegisterFlagEffect(4210010,RESET_EVENT+0xcff0000,0,0)
			if (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) 
				and Duel.SelectYesNo(tp,aux.Stringid(4210037,4)) then
				Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			end
		end
	end
end