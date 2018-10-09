--忍妖 变化之术
function c12017020.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c12017020.target)
	e1:SetOperation(c12017020.activate)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12017020,4))
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,0x1e0)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c12017020.cost)
	e2:SetCondition(c12017020.thcon)
	e2:SetTarget(c12017020.thtg)
	e2:SetOperation(c12017020.thop)
	c:RegisterEffect(e2)  
end
function c12017020.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_GRAVE,0,1,nil,RACE_ZOMBIE)and Duel.GetFlagEffect(tp,12017020)==0 end
	Duel.RegisterFlagEffect(tp,12017020,RESET_CHAIN,0,1)
	local g=Duel.SelectMatchingCard(tp,Card.IsRace,tp,LOCATION_GRAVE,0,1,1,nil,RACE_ZOMBIE) 
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c12017020.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if chk==0 then return h1>0 and Duel.IsPlayerCanDiscardDeck(tp,h1)
	end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,0,1)
end
function c12017020.filter(c)
	return c:IsSetCard(0xfb4) and c:IsAbleToHand()
end
function c12017020.activate(e,tp,eg,ep,ev,re,r,rp)
	local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local h=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.SendtoGrave(h,REASON_EFFECT+REASON_DISCARD)
	Duel.DiscardDeck(tp,h1,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(c12017020.filter,tp,LOCATION_DECK,0,nil)
	if Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)<2  and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(12017020,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c12017020.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
end
function c12017020.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local b1=Duel.GetFlagEffect(tp,12017020+100)==0
	local b2=Duel.GetFlagEffect(tp,12017020+200)==0
	if chk==0 then return b1 or b2 end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,300)
end
function c12017020.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.GetFlagEffect(tp,12017020+100)==0
	local b2=Duel.GetFlagEffect(tp,12017020+200)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(12017020,1),aux.Stringid(12017020,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(12017020,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(12017020,2))+1
	else return end
	if op==0 then
		Duel.Recover(tp,1000,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,12017020+100,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Damage(1-tp,300,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,12017020+200,RESET_PHASE+PHASE_END,0,1)
	end
end
