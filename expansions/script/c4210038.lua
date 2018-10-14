--猫耳天堂-
function c4210038.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,
		function(c)return c:IsFusionSetCard(0xa2f) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_LINK) end,
		function(c)return c:IsType(TYPE_MONSTER) and (c:IsType(TYPE_FUSION) or c:IsType(TYPE_RITUAL)) end,false)
	--spsummon
	local ep=Effect.CreateEffect(c)
	ep:SetDescription(aux.Stringid(4210038,0))
	ep:SetCategory(CATEGORY_SPECIAL_SUMMON)
	ep:SetType(EFFECT_TYPE_QUICK_O)
	ep:SetCode(EVENT_FREE_CHAIN)
	ep:SetRange(LOCATION_PZONE)
	ep:SetCondition(c4210038.spcon)
	ep:SetCost(c4210038.spcost)
	ep:SetTarget(c4210038.sptg)
	ep:SetOperation(c4210038.spop)
	c:RegisterEffect(ep)
	--setcard
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c4210038.setcon)
	e1:SetTarget(c4210038.settg)
	e1:SetOperation(c4210038.setop)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4210038,2))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_RELEASE)
	e2:SetRange(LOCATION_MZONE)	
	e2:SetCondition(c4210038.damcon)
	e2:SetOperation(c4210038.damop)
	c:RegisterEffect(e2) 
	--SPSUMMON
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4210038,3))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_RELEASE)
	e3:SetCost(c4210038.tgcost)
	e3:SetTarget(c4210038.tgtg)
	e3:SetOperation(c4210038.tgop)
	c:RegisterEffect(e3)
end
function c4210038.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp
end
function c4210038.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,2,nil,0xa2f) and
		 Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,4210026) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	Duel.DiscardHand(tp,Card.IsCode,1,1,REASON_COST+REASON_DISCARD,nil,4210026)
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,2,2,nil,0xa2f)	
	Duel.Release(g,REASON_COST)
end
function c4210038.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c4210038.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
end
function c4210038.setfilter(c)
    return c:IsSetCard(0xa2f) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsSSetable()
end
function c4210038.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c4210038.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c4210038.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c4210038.setop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g=Duel.SelectMatchingCard(tp,c4210038.setfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SSet(tp,g:GetFirst())
        Duel.ConfirmCards(1-tp,g)
    end
end
function c4210038.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xa2f) and c:IsType(TYPE_MONSTER)
end
function c4210038.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c4210038.filter,1,nil)
end
function c4210038.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,4210038)
	if Duel.Recover(tp,300,REASON_EFFECT) 
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) then
		local g = Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c4210038.tgfilter(c)
	return c:IsAbleToRemove()
end
function c4210038.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4210038.tgfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c4210038.tgfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c4210038.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function c4210038.tgop(e,tp,eg,ep,ev,re,r,rp)
	local d1=Duel.Draw(tp,1,REASON_EFFECT)
    local d2=Duel.Draw(1-tp,1,REASON_EFFECT)
	if d1==0 or d2==0 then return end
	if (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) 
		and Duel.SelectYesNo(tp,aux.Stringid(4210038,4)) then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end