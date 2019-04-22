--战场女武神 克鲁特
function c11113007.initial_effect(c)
    --pendulum summon
	aux.EnablePendulumAttribute(c)
    --remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11113007,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11113007)
	e2:SetTarget(c11113007.target)
	e2:SetOperation(c11113007.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--salvage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11113007,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_DECKDES)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,11113007)
	e4:SetTarget(c11113007.distg)
	e4:SetOperation(c11113007.disop)
	c:RegisterEffect(e4)
end
function c11113007.filter(c)
	return c:IsSetCard(0x15c) and c:IsType(TYPE_MONSTER) and not c:IsCode(11113007) and c:IsAbleToRemove()
end
function c11113007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e)
	    and Duel.IsExistingMatchingCard(c11113007.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c11113007.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c11113007.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c11113007.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3  end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c11113007.disfilter(c)
	return c:IsSetCard(0x15c) and not c:IsCode(11113007)
end
function c11113007.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if g:GetCount()>0 then
		if g:IsExists(c11113007.disfilter,1,nil) then
			if Duel.SelectYesNo(tp,aux.Stringid(11113007,2)) then
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
				local sg=g:FilterSelect(tp,c11113007.disfilter,1,1,nil)
				if sg:GetFirst():IsAbleToHand() then
					Duel.SendtoHand(sg,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,sg)
					Duel.ShuffleHand(tp)
				else
					Duel.SendtoGrave(sg,REASON_RULE)
				end
			end
		end
		Duel.ShuffleDeck(tp)
	end
end	