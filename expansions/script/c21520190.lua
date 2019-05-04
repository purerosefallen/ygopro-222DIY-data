--艺形魔-纸龙神
function c21520190.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,21520190)
	e1:SetCondition(c21520190.spcon)
	e1:SetOperation(c21520190.spop)
	c:RegisterEffect(e1)
	--atk & def
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
--	e3:SetCondition(c21520190.adcon)
	e3:SetValue(c21520190.adval)
	c:RegisterEffect(e3)
	local e3_2=e3:Clone()
	e3_2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3_2)
	--atk &def
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetDescription(aux.Stringid(21520190,1))
	e4:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c21520190.thcon)
	e4:SetTarget(c21520190.thtg)
	e4:SetOperation(c21520190.thop)
	c:RegisterEffect(e4)
--[[	if not c21520190.global_check then
		c21520190.global_check=true
		c21520190[0]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
		ge1:SetOperation(c21520190.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.GlobalEffect()
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_TURN_END)
		ge2:SetOperation(c21520190.resetop)
		Duel.RegisterEffect(ge2,0)
	end
end
function c21520190.checkop(e,tp,eg,ep,ev,re,r,rp)
	if c21520190[0]<49 then
		c21520190[0]=Duel.GetFlagEffect(e:GetHandlerPlayer(),21520190)
	end
end
function c21520190.resetop(e,tp,eg,ep,ev,re,r,rp)
	if c21520190[0]<49 then
		c21520190[0]=0
	end--]]
end
function c21520190.spfilter(c)
	return c:IsSetCard(0x490) and (not c:IsOnField() or c:IsFaceup()) and c:IsType(TYPE_MONSTER)
end
function c21520190.spcon(e,c)
	if c==nil then return true end
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)<=0 then return false end
	local g=Duel.GetMatchingGroup(c21520190.spfilter,c:GetControler(),LOCATION_ONFIELD+LOCATION_GRAVE,0,e:GetHandler())
	local ct=g:GetClassCount(Card.GetCode)
	return ct>5
end
function c21520190.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c21520190.atktg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c21520190.atktg(e,c)
	return not c:IsSetCard(0x490)
end

function c21520190.filter21(c)
	return c:GetFlagEffect(21520190)~=0
end
function c21520190.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x490)
end
function c21520190.thfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsAbleToHand()
--Group.CheckWithSumEqual(Group g, function f, int sum, int min, int max, ...)
end
function c21520190.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()&(TYPE_SPELL+TYPE_CONTINUOUS)==TYPE_SPELL+TYPE_CONTINUOUS
end
function c21520190.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c21520190.filter(chkc) and chkc:IsLocation(LOCATION_ONFIELD) and chkc:GetControler(tp) end
	if chk==0 then 
		local g=Duel.GetMatchingGroup(c21520190.thfilter,tp,LOCATION_DECK,0,nil)
		return g:CheckWithSumEqual(Card.GetOriginalLevel,7,2,2) and Duel.IsExistingTarget(c21520190.filter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local c=e:GetHandler()
	local g1=Duel.SelectTarget(tp,c21520190.filter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	local dg=Group.FromCards(c,g1:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c21520190.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	local dg=Group.FromCards(c,tc)
	local g=Duel.GetMatchingGroup(c21520190.thfilter,tp,LOCATION_DECK,0,nil)
	if Duel.Destroy(dg,REASON_EFFECT)~=2 or not g:CheckWithSumEqual(Card.GetOriginalLevel,7,2,2) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:SelectWithSumEqual(tp,Card.GetOriginalLevel,7,2,2)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tdg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(tdg,nil,2,REASON_EFFECT)
end
function c21520190.sefilter(c)
	return c:IsSetCard(0x490) and c:IsFaceup()
end
function c21520190.adcon(e)
	return Duel.GetTurnCount()>=49 or c21520190[0]>=49
end
function c21520190.adval(e,c)
	return Duel.GetMatchingGroupCount(c21520190.sefilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*400
--	return Duel.GetTurnCount()*200
end
--[[
function c21520190.adfilter(c)
	return c:IsSetCard(0x490) and c:IsFaceup() and not c:IsCode(21520190)
end
function c21520190.atkval(e,c)
	local g=Duel.GetMatchingGroup(c21520190.adfilter,c:GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local tc=g:GetFirst()
	local sum=0
	while tc do
		sum=sum+tc:GetAttack()
		tc=g:GetNext()
	end
	return sum
end
function c21520190.defval(e,c)
	local g=Duel.GetMatchingGroup(c21520190.adfilter,c:GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local tc=g:GetFirst()
	local sum=0
	while tc do
		sum=sum+tc:GetDefense()
		tc=g:GetNext()
	end
	return sum
end
function c21520190.dr2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) and Duel.IsPlayerCanDraw(1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,nil,2)
end
function c21520190.dr2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsPlayerCanDraw(tp) then return end
	if not Duel.IsPlayerCanDraw(1-tp) then return end
	local player=Duel.GetTurnPlayer()
	local sum={}
	sum[player]=0
	sum[1-player]=0
	local ct=Duel.GetFieldGroupCount(player,LOCATION_DECK,0)
	while Duel.IsPlayerCanDraw(player) and sum[1-player]<21 do
		ct=Duel.GetFieldGroupCount(player,LOCATION_DECK,0)
		local tc=Duel.GetDecktopGroup(player,1):GetFirst()
		Duel.Draw(player,1,REASON_EFFECT)
		Duel.ConfirmCards(1-player,tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
		tc:RegisterFlagEffect(21520190,RESET_EVENT+0x1fe0000+RESET_CHAIN,0,1)
		tc:RegisterEffect(e1)
		local lv=tc:GetOriginalLevel()
		if not tc:IsType(TYPE_MONSTER) then lv=1 end
		sum[player]=sum[player]+lv
		Duel.Hint(HINT_NUMBER,1-player,sum[player])
		player=1-player
	end
	if sum[tp]<21 then 
		local g=Duel.GetMatchingGroup(c21520190.filter21,tp,LOCATION_HAND,0,nil)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	elseif sum[tp]>21 then 
		local g=Duel.GetMatchingGroup(c21520190.filter21,tp,LOCATION_HAND,0,nil)
		Duel.SendtoGrave(g,REASON_EFFECT)
	else 
		local g=Duel.GetMatchingGroup(c21520190.filter21,tp,LOCATION_HAND,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(21520190,3))
		local sg=g:Select(tp,2,2,nil)
		g:Sub(sg)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
	if sum[1-tp]<21 then 
		local g=Duel.GetMatchingGroup(c21520190.filter21,1-tp,LOCATION_HAND,0,nil)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	elseif sum[1-tp]>21 then 
		local g=Duel.GetMatchingGroup(c21520190.filter21,1-tp,LOCATION_HAND,0,nil)
		Duel.SendtoGrave(g,REASON_EFFECT)
	else 
		local g=Duel.GetMatchingGroup(c21520190.filter21,1-tp,LOCATION_HAND,0,nil)
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(21520190,3))
		local sg=g:Select(1-tp,2,2,nil)
		g:Sub(sg)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c21520190.ctfilter(c)
	return c:IsCode(21520190) and c:IsFaceup()
end
function c21520190.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,21520190,RESET_PHASE+PHASE_END,0,1)
	local g=Duel.GetMatchingGroup(c21520190.ctfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	while tc do
		tc:SetHint(CHINT_NUMBER,c21520190[0]+1)
		tc=g:GetNext()
	end
end
--]]