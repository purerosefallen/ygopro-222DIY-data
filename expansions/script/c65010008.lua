--「为了适应超出我体系的环境」
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=65010008
local cm=_G["c"..m]
cm.card_code_list={65010001}
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	e1:SetCondition(cm.con)
	local e2=rsef.QO(c,nil,{m,0},{1,m},"eq,sp",{"tg",EFFECT_FLAG_NO_TURN_RESET },LOCATION_SZONE,nil,nil,cm.tg,cm.op)
end
function cm.con(e,tp)
	local f=function(c)
		return c:IsFacedown() or not c:IsType(TYPE_NORMAL)
	end
	return not Duel.IsExistingMatchingCard(f,tp,LOCATION_MZONE,0,1,nil)
end
function cm.cfilter(c,e,tp)
	if not c:IsFaceup() then return false end
	if c:IsLocation(LOCATION_GRAVE) then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
	else return true
	end
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return
		((chkc:IsLocation(LOCATION_GRAVE) and chkc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or chkc:IsLocation(LOCATION_MZONE)) and chkc:IsFaceup() and chkc:IsControler(tp) and chkc:IsCode(65010001)
	end
	if chk==0 then return Duel.IsExistingTarget(cm.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,cm.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.op(e,tp)
	local tc=rscf.GetTargetCard()
	local c=aux.ExceptThisCard(e)
	if not c then return end
	if not tc and c then Duel.SendtoGrave(c,REASON_RULE) return end
	if tc and c then
		if tc:IsLocation(LOCATION_GRAVE) then
			if rssf.SpecialSummon(tc)<=0 then Duel.SendtoGrave(c,REASON_RULE) return end
		end
		if rsop.eqop(e,c,tc) then
			local e1=rsef.QO(c,nil,{m,1},1,nil,nil,LOCATION_SZONE,rscon.phmp,nil,cm.settg,cm.setop,nil,rsreset.est)
		end
	end
end
function cm.setfilter(c)
	return aux.IsCodeListed(c,65010001) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		if tc:IsType(TYPE_QUICKPLAY) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		elseif tc:IsType(TYPE_TRAP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		Duel.ConfirmCards(1-tp,g)
	end
end