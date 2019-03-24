--龙棋兵团 掌旗官
if not pcall(function() require("expansions/script/c18006001") end) then require("script/c18006001") end
local m=18006007
local cm=_G["c"..m]
cm.rssetcode="DragonChessCorps"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.lfilter,1) 
	local e3=rsef.I(c,{m,1},{1,3},"th","tg",LOCATION_MZONE,nil,nil,rstg.target({cm.thfilter,"th",LOCATION_ONFIELD,LOCATION_ONFIELD },rsop.list(cm.tffilter,nil,LOCATION_HAND)),cm.thop)
	local e4=rsef.QO_OPPONENT_TURN(c,e3,cm.qocon)
	--search
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(aux.mskregcon)
	e0:SetOperation(aux.mskreg)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.thcon2)
	e1:SetTarget(cm.thtg2)
	e1:SetOperation(cm.thop2)
	c:RegisterEffect(e1)
end
function cm.qocon(e,tp)
	local c=e:GetHandler()
	return c:GetColumnGroup():FilterCount(cm.qofilter,c)>=2
end
function cm.qofilter(c)
	return c:IsFaceup() and rsdcc.IsSet(c)
end 
function cm.thfilter(c,e,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and (c:IsControler(tp) or Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
end
function cm.tffilter(c,e,tp)
	return c:GetType()&TYPE_SPELL+TYPE_CONTINUOUS ==TYPE_SPELL+TYPE_CONTINUOUS and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function cm.thop(e,tp)
	local tc=rscf.GetTargetCard()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc2=Duel.SelectMatchingCard(tp,cm.tffilter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
		if tc2 then
			Duel.MoveToField(tc2,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
		
	end
end
function cm.lfilter(c)
	return c:CheckLinkSetCard("DragonChessCorps") and c:IsType(TYPE_NORMAL)
end
function cm.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(ev)>0
end
function cm.thfilter2(c)
	return rsdcc.filter(c) and c:IsAbleToHand()
end
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

