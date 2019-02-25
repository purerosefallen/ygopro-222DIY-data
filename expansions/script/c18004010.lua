--性感手枪二点射
if not pcall(function() require("expansions/script/c18004001") end) then require("script/c18004001") end
local m=18004010
local cm=_G["c"..m]
cm.rssetcode="SexGun"
function cm.initial_effect(c)
	rssg.SexGunCode(c)   
	aux.AddSynchroProcedure(c,nil,aux.FilterBoolFunction(Card.IsCode,18004005),1,1)
	c:EnableReviveLimit()   
	local e1=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},{1,m},nil,"de",rscon.sumtype("syn"),nil,cm.tg,cm.op)
	local e2=rsef.QO(c,nil,{m,1},nil,"sp",nil,LOCATION_MZONE,cm.con2,nil,cm.tg2,cm.op2)
end
function cm.con2(e,tp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,6,nil,18004005)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local f=function(c)
		return c:IsCode(18004005) and c:IsFaceup()
	end
	local mg=Duel.GetMatchingGroup(f,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,mg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local f=function(c)
		return c:IsCode(18004005) and c:IsFaceup()
	end
	local mg=Duel.GetMatchingGroup(f,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil,mg)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
	end
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.setfilter(c)
	return rssg.IsSexGun(c) and c:IsType(TYPE_QUICKPLAY) and c:IsSSetable()
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
	   Duel.SSet(tp,tc)
	   Duel.ConfirmCards(1-tp,tc)
	end
end
