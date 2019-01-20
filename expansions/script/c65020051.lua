--暮色居城的朝晖
function c65020051.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65020051+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65020051.thtg)
	e1:SetOperation(c65020051.thop)
	c:RegisterEffect(e1)
	 --atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5da1))
	e2:SetValue(c65020051.val)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c65020051.con)
	e3:SetValue(aux.tgoval)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5da1))
	c:RegisterEffect(e3)
end
function c65020051.val(e,c)
	return Duel.GetMatchingGroupCount(Card.IsFacedown,c:GetControler(),LOCATION_REMOVED,0,nil)*50
end
function c65020051.con(e,c)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	local b=Duel.GetFieldGroupCount(tp,0,LOCATION_REMOVED)
	return a>b 
end
function c65020051.thfil(c,tp)
	local lv=c:GetLevel()
	return c:IsSetCard(0x5da1) and c:IsType(TYPE_MONSTER) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=lv 
end
function c65020051.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65020051.thfil,tp,LOCATION_DECK,0,1,nil,tp) and Duel.GetFieldGroup(tp,LOCATION_DECK,0):IsExists(Card.IsAbleToRemove,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c65020051.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c65020051.thfil,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,tp,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g)
			local lv=g:GetFirst():GetLevel()
			local rg=Duel.GetDecktopGroup(tp,lv)
			Duel.DisableShuffleCheck()
			Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end