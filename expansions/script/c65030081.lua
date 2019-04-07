--相遇的瞬间
function c65030081.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(c65030081.synfil),1)
	--merry-go-round
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c65030081.con)
	e1:SetTarget(c65030081.tg)
	e1:SetOperation(c65030081.op)
	c:RegisterEffect(e1)
	--tuner!
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c65030081.sptg)
	e2:SetOperation(c65030081.spop)
	c:RegisterEffect(e2)
	--pendulum
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCondition(c65030081.pencon)
	e6:SetTarget(c65030081.pentg)
	e6:SetOperation(c65030081.penop)
	c:RegisterEffect(e6)
end
c65030081.card_code_list={65030086}
function c65030081.synfil(c)
	return aux.IsCodeListed(c,65030086)
end
function c65030081.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c65030081.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local num=Duel.GetMatchingGroupCount(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,num,tp,LOCATION_HAND)
	if num<=3 then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,tp,num+1)
	else
		Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,tp,num)
	end
end
function c65030081.op(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetMatchingGroupCount(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)>0 and Duel.IsPlayerCanDraw(tp)) then return end
	local tgg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
	local tgn=Duel.SendtoDeck(tgg,nil,2,REASON_EFFECT)
	if tgn>0 and Duel.IsPlayerCanDraw(tp) then
		Duel.ShuffleDeck(tp)
		if tgn<=3 then
			Duel.Draw(tp,tgn+1,REASON_EFFECT)
		else
			Duel.Draw(tp,tgn,REASON_EFFECT)
		end
	end
end

function c65030081.spfil(c,e,tp)
	return aux.IsCodeListed(c,65030086) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65030081.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65030081.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c65030081.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.SelectMatchingCard(tp,c65030081.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.SelectYesNo(tp,aux.Stringid(65030081,0)) then
			local c=e:GetHandler()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_TYPE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(TYPE_TUNER)
			c:RegisterEffect(e1)
		end
	end
end

function c65030081.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c65030081.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c65030081.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
